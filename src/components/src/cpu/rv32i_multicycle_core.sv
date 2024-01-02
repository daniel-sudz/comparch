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
    
    enum logic [1:0] {S_FETCH, S_DECODE} state;

    parameter [31:0] PC_START_ADDRESS = {MMU_BANK_INST, 28'h0};


    /* ---------------------- Standard Control Signals ---------------------- */
    input  wire clk, rst, ena; // <- worry about implementing the ena signal last.
    output logic instruction_done; // Should be high for one clock cycle when finishing an instruction (e.g. during the writeback state).

    /* ---------------------- Memory Interface ---------------------- */
    output logic [31:0] mem_addr, mem_wr_data;
    input   wire [31:0] mem_rd_data;
    output mem_access_t mem_access;
    input mem_exception_mask_t mem_exception;
    output logic mem_wr_ena;

    /* ---------------------- Program Counter ---------------------- */
    output wire [31:0] PC;
    output logic [31:0] instructions_completed; // TODO(student) - increment this by one whenever an instruction is complete.
    wire [31:0] PC_old;
    logic PC_ena, PC_old_ena;
    logic [31:0] PC_next;

    /* ---------------------- Instruction Decoder ---------------------- */
    logic [6:0] op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rd, rs1, rs2;
    logic [31:0] extended_immediate;

    logic rtype, itype, ltype, stype, btype, jtype;

    always_comb op = IR[6:0];
    always_comb funct3 = IR[14:12];
    always_comb rs1 = IR[19:15];
    always_comb rs2 = IR[24:20];

    always_comb begin : instruction_type_decoder
        if(op == 6'd3 || op == 6'd19) begin
            itype = 1;
            rtype = 0;
        end else if(op == 6'd51) begin
            itype = 0;
            rtype = 1;
        end
    end

    always_comb begin : extended_immediate_decoder
        if(itype) begin
            extended_immediate = {{20{IR[31]}}, IR[31:25]};
        end
    end


    /* ---------------------- Control Signals [R-file] ---------------------- */
    wire [31:0] reg_data1, reg_data2;
    logic reg_write;
    logic [31:0] rfile_wr_data;
    wire [31:0] reg_A, reg_B;

    /* ---------------------- Control Signals [ALU] ---------------------- */
    logic [31:0] src_a, src_b;
    wire [31:0] alu_result;
    alu_control_t alu_control, ri_alu_control;
    wire overflow;
    wire zero;
    wire equal;


   /* ---------------------- Non-Architectural Register Signals ---------------------- */
    logic ALU_ena;
    wire [31:0] alu_last; // Not a descriptive name, but this is what it's called in the text.
    logic mem_data_ena;
    wire [31:0] mem_data;
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    enum logic [1:0] {RESULT_SRC_ALU, RESULT_SRC_MEM_DATA, RESULT_SRC_ALU_LAST} result_src; 
    logic [31:0] result;

    /* ---------------------- Instruction Register ---------------------- */
    logic [31:0] IR, IR_next;
    logic IR_write;
    register #(.N(32), .RESET_VALUE(32'b0)) IR_REGISTER (
    .clk(clk), .rst(rst), .ena(IR_write), .d(IR_next), .q(IR)
    );

    /* ---------------------- Program Counter Register ---------------------- */
    register #(.N(32), .RESET_VALUE(PC_START_ADDRESS)) PC_REGISTER (
    .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
    );

    /* ---------------------- Register File ---------------------- */
    register_file REGISTER_FILE(
    .clk(clk), .rst(rst),
    .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
    .rd_addr0(rs1), .rd_addr1(rs2),
    .rd_data0(reg_data1), .rd_data1(reg_data2)
    );

    task print_rfile();
        REGISTER_FILE.print_state();
    endtask

    // Non-architecture register: save register read data for future cycles.
    register #(.N(32)) REGISTER_A (.clk(clk), .rst(rst), .ena(1'b1), .d(reg_data1), .q(reg_A));
    register #(.N(32)) REGISTER_B (.clk(clk), .rst(rst), .ena(1'b1), .d(reg_data2), .q(reg_B));
    always_comb mem_wr_data = reg_B; // RISC-V always stores data from this location.

    /* ---------------------- ALU ---------------------- */
    alu ALU (
    .a(src_a), .b(src_b), .result(alu_result),
    .control(alu_control),
    .overflow(overflow), .zero(zero), .equal(equal)
    );


    /* ---------------------- Memory Read Multiplexor ---------------------- */
    always_comb begin : multiplexor_mem_read
        case(state)
            S_FETCH: begin
                mem_access = MEM_ACCESS_BYTE;
                mem_addr = PC;
            end
        endcase
    end

    /* ---------------------- Instruction Register Multiplexor ---------------------- */
    always_comb IR_write = (state == S_FETCH) ? 1 : 0;
    always_comb IR_next = mem_rd_data;


    /* ---------------------- ALU Control Multiplexor ---------------------- */
    always_comb begin : multiplexor_alu_control 
        case(state)
            /* In the fetch state, the ALU is used to increment the PC by 4 */
            S_FETCH: begin
                alu_control = ALU_ADD;
                src_a = PC;
                src_b = 32'd4;
            end 
        endcase
    end

    /* ---------------------- Program Counter Multiplexor ---------------------- */
    always_comb begin : multiplexor_pc
        case(state)
            S_FETCH: begin
                PC_next = alu_result;
            end 
        endcase
    end


    /* ---------------------- CPU Controller State Machine ---------------------- */
    always_ff @(posedge clk) begin : rv32i_multicycle_core
        if(rst) begin
            state <= S_FETCH;
        end else begin
            case(state) 
                S_FETCH: state <= S_DECODE;
            endcase 
        end

    end


endmodule