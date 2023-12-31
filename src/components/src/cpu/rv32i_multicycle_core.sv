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

    parameter PC_START_ADDRESS = {MMU_BANK_INST, 28'h0};

    // Standard control signals.
    input  wire clk, rst, ena; // <- worry about implementing the ena signal last.
    output logic instruction_done; // Should be high for one clock cycle when finishing an instruction (e.g. during the writeback state).

    // Memory interface.
    output logic [31:0] mem_addr, mem_wr_data;
    input   wire [31:0] mem_rd_data;
    output mem_access_t mem_access;
    input mem_exception_mask_t mem_exception;
    output logic mem_wr_ena;

    // Program Counter
    output wire [31:0] PC;
    output logic [31:0] instructions_completed; // TODO(student) - increment this by one whenever an instruction is complete.
    wire [31:0] PC_old;
    logic PC_ena, PC_old_ena;
    logic [31:0] PC_next;

    // Control Signals
    // Decoder
    logic [6:0] op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic rtype, itype, ltype, stype, btype, jtype;
    enum logic [2:0] {IMM_SRC_ITYPE, IMM_SRC_STYPE, IMM_SRC_BTYPE, IMM_SRC_JTYPE, IMM_SRC_UTYPE} immediate_src;
    logic [31:0] extended_immediate;

    // R-file Control Signals
    logic [4:0] rd, rs1, rs2;
    wire [31:0] reg_data1, reg_data2;
    logic reg_write;
    logic [31:0] rfile_wr_data;
    wire [31:0] reg_A, reg_B;

    // ALU Control Signals
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

    // Non-architectural Register Signals
    logic IR_write;
    wire [31:0] IR; // Instruction Register (current instruction)
    logic ALU_ena;
    wire [31:0] alu_last; // Not a descriptive name, but this is what it's called in the text.
    logic mem_data_ena;
    wire [31:0] mem_data;
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    enum logic [1:0] {RESULT_SRC_ALU, RESULT_SRC_MEM_DATA, RESULT_SRC_ALU_LAST} result_src; 
    logic [31:0] result;

    // Program Counter Register
    register #(.N(32), .RESET_VALUE(PC_START_ADDRESS)) PC_REGISTER (
    .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
    );

    // Register file
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

    // ALU and related control signals - use the behavioral one if you need to.
    alu ALU (
    .a(src_a), .b(src_b), .result(alu_result),
    .control(alu_control),
    .overflow(overflow), .zero(zero), .equal(equal)
    );


endmodule