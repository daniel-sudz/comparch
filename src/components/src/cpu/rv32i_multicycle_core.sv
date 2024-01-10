`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "memory_access.sv"
`include "memory_exceptions.sv"
`include "rv32_common.sv"
`include "memory_map.sv" 

module rv32i_multicycle_core(
        clk, rst, ena,
        mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
        mem_access, mem_exception,
        PC, instructions_completed, instruction_done
    );

    `define OP_IMMEDIATE_I_EXECUTE 7'b0010011
    `define OP_I_LOAD 7'b0000011
    `define OP_R_EXECUTE 7'b0110011
    `define OP_I_STORE 7'b0100011
    `define OP_BRANCH 7'b1100011
    `define OP_JAL 7'b1101111
    `define OP_JALR 7'b1100111
    `define OP_U_IPC 7'b0010111
    `define OP_U_LUI 7'b0110111
    
    /* enum values assigned for debug purposes. Sync them with the gtkwave folder */
    enum logic [3:0] {
        S_FETCH = 0, 
        S_DECODE = 1, 
        S_MEMADR = 2, 
        S_MEMREAD = 3, 
        S_MEMWB = 4, 
        S_EXECUTE_RI = 5, 
        S_ALUWB = 6, 
        S_MEMWRITE = 7,
        S_BRANCH = 8,
        S_JAL = 9
    } state;

    /* ---------------------- Standard Control Signals ---------------------- */
    input  wire clk, rst, ena; // <- worry about implementing the ena signal last.
    output logic instruction_done; // Should be high for one clock cycle when finishing an instruction (e.g. during the writeback state).

    /* ---------------------- Memory Interface ---------------------- */
    output logic [31:0] mem_addr, mem_wr_data;
    input   wire [31:0] mem_rd_data;
    output mem_access_t mem_access;
    input mem_exception_mask_t mem_exception;
    output logic mem_wr_ena;

    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              Instruction Decoder (begin)                                           */
    /* -------------------------------------------------------------------------------------------------------------------*/
    logic [6:0] op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rd, rs1, rs2;
    logic [31:0] extended_immediate;

    always_comb op = IR[6:0];
    always_comb funct3 = IR[14:12];
    always_comb funct7 = IR[31:25];
    always_comb rd = IR[11:7];
    always_comb rs1 = IR[19:15];
    always_comb rs2 = IR[24:20];

    always_comb begin : extended_immediate_decoder
        case(op)
            `OP_IMMEDIATE_I_EXECUTE, `OP_I_LOAD: extended_immediate = {{20{IR[31]}}, IR[31:20]};
            `OP_I_STORE:                         extended_immediate = {{20{IR[31]}}, IR[31:25], IR[11:7]};
            `OP_BRANCH:                          extended_immediate = {{19{IR[31]}}, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
            `OP_JAL, `OP_JALR:                   extended_immediate = {{11{IR[31]}}, IR[31], IR[19:12], IR[20], IR[30:21], 1'b0};
            `OP_U_IPC, `OP_U_LUI:                extended_immediate = {IR[31:12], 12'b0};
        endcase
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              Instruction Decoder (end)                                             */
    /* -------------------------------------------------------------------------------------------------------------------*/


    /* ---------------------- Control Signals [R-file] ---------------------- */
    wire [31:0] reg_data1, reg_data2;
    logic reg_write;
    wire [31:0] reg_A, reg_B;

    /* ---------------------- Control Signals [ALU] ---------------------- */
    enum logic [1:0] {ALU_SRC_A_PC, ALU_SRC_A_RF, ALU_SRC_A_OLD_PC, ALU_SRC_A_ZERO} 
    alu_src_a;
    enum logic [1:0] {ALU_SRC_B_RF, ALU_SRC_B_IMM, ALU_SRC_B_4, ALU_SRC_B_ZERO} 
    alu_src_b;
    logic [31:0] src_a, src_b;
    wire [31:0] alu_result;
    alu_control_t alu_control, ri_alu_control;
    wire overflow;
    wire zero;
    wire equal;


   /* ---------------------- Non-Architectural Register Signals ---------------------- */
    logic alu_last_ena;
    wire [31:0] alu_last; // Not a descriptive name, but this is what it's called in the text.
    logic mem_data_ena;
    wire [31:0] mem_data;
    enum logic [2:0] {MEM_SRC_PC, MEM_SRC_ALU_LAST, MEM_SRC_RESULT} mem_src;

    always_comb begin : mem_src_signals
        case(mem_src)
            MEM_SRC_PC: mem_addr = PC;
            MEM_SRC_ALU_LAST: mem_addr = alu_last;
        endcase
    end
    

    register #(.N(32), .RESET_VALUE(32'b0)) ALU_RESULT_REGISTER (
    .clk(clk), .rst(rst), .ena(alu_last_ena), .d(alu_result), .q(alu_last)
    );

    register #(.N(32), .RESET_VALUE(32'b0)) MEM_DATA_REGISTER (
    .clk(clk), .rst(rst), .ena(mem_data_ena), .d(mem_rd_data), .q(mem_data)
    );
    

    /* ---------------------- Result SRC Signals ---------------------- */
    enum logic [1:0] {RESULT_SRC_ALU, RESULT_SRC_MEM_DATA, RESULT_SRC_ALU_LAST, RESULT_SRC_PC_NEXT_INSTRUCTION} result_src; 
    logic [31:0] result;

    always_comb begin : result_signals
        case(result_src)
            RESULT_SRC_ALU: result = alu_result;
            RESULT_SRC_MEM_DATA: result = mem_data;
            RESULT_SRC_ALU_LAST: result = alu_last;
            RESULT_SRC_PC_NEXT_INSTRUCTION: result = PC_next_instruction;
        endcase
    end

    /* ---------------------- Instruction Register ---------------------- */
    logic [31:0] IR, IR_next;
    logic IR_write;
    register #(.N(32), .RESET_VALUE(32'b0)) IR_REGISTER (
    .clk(clk), .rst(rst), .ena(IR_write), .d(IR_next), .q(IR)
    );

    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              Program Counter States (begin)                                        */
    /* -------------------------------------------------------------------------------------------------------------------*/
    output wire [31:0] PC;
    parameter [31:0] PC_START_ADDRESS = {MMU_BANK_INST, 28'h0};
    output logic [31:0] instructions_completed; // TODO(student) - increment this by one whenever an instruction is complete.

    logic PC_ena, PC_old_ena, PC_next_instruction_ena;
    logic [31:0] PC_old, PC_next, PC_next_jump, PC_next_instruction;

    enum logic [2:0] {PC_NEXT_JUMP, PC_NEXT_INSTRUCTION} pc_next_src;

    always_comb begin : pc_next_src_multiplexor
        case(pc_next_src)
            PC_NEXT_INSTRUCTION: PC_next = PC_next_instruction;
            PC_NEXT_JUMP: PC_next = alu_last;
        endcase
    end

    register #(.N(32), .RESET_VALUE(PC_START_ADDRESS)) PC_REGISTER (.clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC));
    register #(.N(32), .RESET_VALUE('x)) PC_NEXT_INSTRUCTION_REGISTER (.clk(clk), .rst(rst), .ena(PC_next_instruction_ena), .d(alu_result), .q(PC_next_instruction));
    register #(.N(32), .RESET_VALUE('x)) PC_OLD_REGISTER (.clk(clk), .rst(rst), .ena(PC_old_ena), .d(PC), .q(PC_old));
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              Program Counter States (end)                                          */
    /* -------------------------------------------------------------------------------------------------------------------*/

    /* ---------------------- Register File ---------------------- */
    register_file REGISTER_FILE(
    .clk(clk), .rst(rst),
    .wr_ena(reg_write), .wr_addr(rd), .wr_data(result),
    .rd_addr0(rs1), .rd_addr1(rs2),
    .rd_data0(reg_data1), .rd_data1(reg_data2)
    );

    task print_rfile;
        REGISTER_FILE.print_state();
    endtask

    // Non-architecture register: save register read data for future cycles.

    register #(.N(32)) REGISTER_A (.clk(clk), .rst(rst), .ena(1'b1), .d(reg_data1), .q(reg_A));
    register #(.N(32)) REGISTER_B (.clk(clk), .rst(rst), .ena(1'b1), .d(reg_data2), .q(reg_B));
    always_comb mem_wr_data = reg_B; // RISC-V always stores data from this location.

    /* ---------------------- ALU ---------------------- */
    alu #(.ACCOUNT_SHIFT_OVERFLOW(0)) ALU (
    .a(src_a), .b(src_b), .result(alu_result),
    .control(alu_control),
    .overflow(overflow), .zero(zero), .equal(equal)
    );

    /* ---------------------- Instruction Register Multiplexor ---------------------- */
    always_comb IR_next = mem_rd_data;
     

    /* ---------------------- ALU Control Multiplexor ---------------------- */
    always_comb begin : multiplexor_alu_control 
        case(alu_src_a) 
            ALU_SRC_A_PC: src_a = PC;
            ALU_SRC_A_RF: src_a = reg_A;
            ALU_SRC_A_OLD_PC: src_a = PC_old;
            ALU_SRC_A_ZERO: src_a = 0;
        endcase
        case(alu_src_b) 
            ALU_SRC_B_RF: src_b = reg_B;
            ALU_SRC_B_IMM: src_b = extended_immediate;
            ALU_SRC_B_4: src_b = 32'd4;
            ALU_SRC_B_ZERO: src_b = 0;
        endcase
    end

    /* ---------------------- Default Values ---------------------- */
    task automatic set_default;
            // all enables are false unless explicitely asserted
            PC_old_ena = 0;
            PC_ena = 0;
            PC_next_instruction_ena = 0;
            IR_write = 0;
            alu_last_ena = 0;
            mem_data_ena = 0;
            mem_wr_ena = 0;
            reg_write = 0;
    endtask
 
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for LOADS/STORES (begin)                                     */
    /* -------------------------------------------------------------------------------------------------------------------*/
    always_comb begin : datapath_load
        // mem_access is set the same for store/load during S_MEMREAD and S_MEMWRITE phases
        // special case for S_FETCH below where it swaps to MEM_ACCESS_WORD
        case(funct3)
            3'b000: mem_access = MEM_ACCESS_BYTE;
            3'b001: mem_access = MEM_ACCESS_HALF;
            3'b010: mem_access = MEM_ACCESS_WORD;
        endcase

        case(state) 
            S_FETCH: begin 
                set_default;
                // fetch the PC from memory
                mem_src = MEM_SRC_PC;
                mem_access = MEM_ACCESS_WORD;
                // write PC to IR
                IR_write = 1;
                // compute (PC + 4) into PC_next
                alu_control = ALU_ADD;
                alu_src_a = ALU_SRC_A_PC;
                alu_src_b = ALU_SRC_B_4;
                PC_old_ena = 1;
                PC_next_instruction_ena = 1;
            end
            // LOAD INSTRUCTION compute offset
            S_MEMADR: begin 
                set_default;
                alu_control = ALU_ADD;
                alu_src_a = ALU_SRC_A_RF;
                alu_src_b = ALU_SRC_B_IMM;
                alu_last_ena = 1;
            end
            // LOAD INSTRUCTION read from mem 
            S_MEMREAD: begin
                set_default;
                mem_src = MEM_SRC_ALU_LAST;
                mem_data_ena = 1;
            end
            // STORE INSTRUCTION write to mem 
            S_MEMWRITE: begin 
                set_default;
                mem_wr_ena = 1;
                mem_src = MEM_SRC_ALU_LAST;
                pc_next_src = PC_NEXT_INSTRUCTION;
                PC_ena = 1;
            end
            // LOAD INSTRUCTION write back to RF 
            S_MEMWB: begin
                set_default;
                result_src = RESULT_SRC_MEM_DATA;
                reg_write = 1;
                pc_next_src = PC_NEXT_INSTRUCTION;
                PC_ena = 1;
            end
        endcase 
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for LOADS/STORES (end)                                       */
    /* -------------------------------------------------------------------------------------------------------------------*/

    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for RI (begin)                                               */
    /* -------------------------------------------------------------------------------------------------------------------*/
    always_comb begin : datapath_ri
        case(state)
            S_EXECUTE_RI: begin
                set_default;
                alu_src_a = ALU_SRC_A_RF;
                case(op)
                    `OP_IMMEDIATE_I_EXECUTE: alu_src_b = ALU_SRC_B_IMM;
                    default : alu_src_b = ALU_SRC_B_RF;
                endcase 
                alu_last_ena = 1;

                case(op)
                     /* I-type instructions below */
                    `OP_IMMEDIATE_I_EXECUTE: begin
                        case(funct3)
                                3'b000: alu_control = ALU_ADD; 
                                3'b010: alu_control = ALU_SLT;
                                3'b011: alu_control = ALU_SLTU;
                                3'b100: alu_control = ALU_XOR; 
                                3'b110: alu_control = ALU_OR;
                                3'b111: alu_control = ALU_AND;
                                3'b001: alu_control = ALU_SLL;
                                3'b101: begin
                                /* func7 is implicitely used to differentiate these two ops */
                                    case(funct7)
                                        7'b0000000: alu_control = ALU_SRL;
                                        7'b0100000: alu_control = ALU_SRA;
                                    endcase
                                end
                        endcase
                    end
                    /* R-type instruction below */
                    `OP_R_EXECUTE: begin
                        case({funct3, funct7})
                                {3'b000, 7'b0000000}: alu_control = ALU_ADD;
                                {3'b000, 7'b0100000}: alu_control = ALU_SUB;
                                {3'b001, 7'b0000000}: alu_control = ALU_SLL;
                                {3'b010, 7'b0000000}: alu_control = ALU_SLT;
                                {3'b011, 7'b0000000}: alu_control = ALU_SLTU;
                                {3'b100, 7'b0000000}: alu_control = ALU_XOR;
                                {3'b101, 7'b0000000}: alu_control = ALU_SRL;
                                {3'b101, 7'b0100000}: alu_control = ALU_SRA;
                                {3'b110, 7'b0000000}: alu_control = ALU_OR;
                                {3'b111, 7'b0000000}: alu_control = ALU_AND;
                        endcase
                    end
                endcase
            end

        endcase 
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for RI (end)                                                 */
    /* -------------------------------------------------------------------------------------------------------------------*/
    
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for ALU WB (begin)                                           */
    /* -------------------------------------------------------------------------------------------------------------------*/
    always_comb begin: datapath_aluwb
        case(state)
            S_ALUWB: begin
                set_default;
                reg_write = 1;
                PC_ena = 1;
                case(op) 
                    `OP_R_EXECUTE, `OP_IMMEDIATE_I_EXECUTE: begin
                        result_src = RESULT_SRC_ALU_LAST;
                        pc_next_src = PC_NEXT_INSTRUCTION;
                    end
                    `OP_JAL: begin
                        result_src = RESULT_SRC_PC_NEXT_INSTRUCTION;
                        pc_next_src = PC_NEXT_JUMP;
                    end
                    `OP_JALR: begin
                        result_src = RESULT_SRC_PC_NEXT_INSTRUCTION;
                        pc_next_src = PC_NEXT_JUMP;
                    end
                endcase
            end
        endcase
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for ALU WB (end)                                             */
    /* -------------------------------------------------------------------------------------------------------------------*/

    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for decode / branch target (begin)                           */
    /* -------------------------------------------------------------------------------------------------------------------*/
    always_comb begin: datapath_decode
        case(state)
                // use the alu in this phase to compute jump target if needed
                S_DECODE: begin
                    set_default;
                    alu_control = ALU_ADD;
                    alu_last_ena = 1;
                    case(op)
                        `OP_BRANCH: begin
                            alu_src_a = ALU_SRC_A_OLD_PC;
                            alu_src_b = ALU_SRC_B_IMM;
                        end
                        `OP_JAL: begin
                            alu_src_a = ALU_SRC_A_OLD_PC;
                            alu_src_b = ALU_SRC_B_IMM;
                        end
                        `OP_JALR: begin
                            alu_src_a = ALU_SRC_A_RF;
                            alu_src_b = ALU_SRC_B_IMM;
                        end
                    endcase
                end
        endcase
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for decode / branch target (end)                             */
    /* -------------------------------------------------------------------------------------------------------------------*/
     
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for branch (begin)                                           */
    /* -------------------------------------------------------------------------------------------------------------------*/
    logic will_jump;
    always_comb begin: datapath_branch
        case(state)
            S_BRANCH: begin
                set_default;
                alu_src_a = ALU_SRC_A_RF;
                alu_src_b = ALU_SRC_B_RF;
                case(funct3)
                    // branch equal
                    3'b000: begin               
                        will_jump = equal;
                    end        
                    // branch not equal                   
                    3'b001: begin               
                        will_jump = ~equal;
                    end
                    // branch less than
                    3'b100: begin               
                        alu_control = ALU_SLT;   
                        will_jump = alu_result[0];
                    end
                    // branch greater or equal
                    3'b101: begin               
                        alu_control = ALU_SLT;  
                        will_jump = ~alu_result[0];    
                    end
                     // branch less than unsigned
                    3'b110: begin              
                        alu_control = ALU_SLTU;
                        will_jump = alu_result[0];
                    end
                    // branch greater than or equal unsigned
                    3'b111: begin               
                        alu_control = ALU_SLTU;
                        will_jump = ~alu_result[0];
                    end     
                endcase
                PC_ena = 1;
                case(will_jump)
                        1'b0: begin
                            pc_next_src = PC_NEXT_INSTRUCTION;
                        end
                        1'b1: begin
                            pc_next_src = PC_NEXT_JUMP;
                        end
                endcase
                end
        endcase
 
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              DATAPATH for branch (end)                                             */
    /* -------------------------------------------------------------------------------------------------------------------*/

    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              CPU Controller State Machine (begin)                                  */
    /* -------------------------------------------------------------------------------------------------------------------*/
    always_ff @(posedge clk) begin : rv32i_multicycle_core
        if(rst) begin
            state <= S_FETCH;
        end else begin
            case(state) 
                S_FETCH: state <= S_DECODE;
                S_DECODE: begin
                    case(op)
                        `OP_I_LOAD: state <= S_MEMADR;
                        `OP_I_STORE: state <= S_MEMADR;
                        `OP_IMMEDIATE_I_EXECUTE: state <= S_EXECUTE_RI;
                        `OP_R_EXECUTE: state <= S_EXECUTE_RI;
                        `OP_BRANCH: state <= S_BRANCH;
                        `OP_JAL: state <= S_ALUWB;
                        `OP_JALR: state <= S_ALUWB;
                    endcase
                end
                S_EXECUTE_RI: state <= S_ALUWB;
                S_ALUWB: state <= S_FETCH;
                S_MEMADR: begin
                    case(op)
                        `OP_I_LOAD: state <= S_MEMREAD;
                        `OP_I_STORE: state <= S_MEMWRITE;
                    endcase
                end
                S_MEMREAD: state <= S_MEMWB;
                S_MEMWB: state <= S_FETCH;
                S_MEMWRITE: state <= S_FETCH;
                S_BRANCH: state <= S_FETCH;
            endcase 
        end
    end
    /* -------------------------------------------------------------------------------------------------------------------*/
    /*                                              CPU Controller State Machine (end)                                    */
    /* -------------------------------------------------------------------------------------------------------------------*/

endmodule