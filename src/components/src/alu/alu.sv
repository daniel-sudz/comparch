`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
    parameter N = 32;
    
     /* ----- Inputs  ----- */
    input wire signed [N-1:0] a, b;
    input alu_control_t control;

     /* ----- Outputs  ----- */
    output logic signed [N-1:0] result;                 // Result of the selected operation.

    output logic overflow;                              // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
    output logic zero;                                  // Is high if the result is ever all zeros.
    output logic equal;                                 // is high if a == b.

    /* ----- Output Operations  ----- */
    logic [N-1:0] RESULT_ALU_AND; 
    logic [N-1:0] RESULT_ALU_OR; 
    logic [N-1:0] RESULT_ALU_XOR;
    logic [N-1:0] RESULT_ALU_SLL;
    logic [N-1:0] RESULT_ALU_SRL;
    logic [N-1:0] RESULT_ALU_SRA;
    logic [N-1:0] RESULT_ALU_ADD;
    logic [N-1:0] RESULT_ALU_SUB;
    logic [N-1:0] RESULT_ALU_SLT;
    logic [N-1:0] RESULT_ALU_SLTU;
    
    

     /* ----- Mux Operation Results  ----- */
    mux16 result_mux(
        .in0(RESULT_ALU_AND),
        .in1(RESULT_ALU_OR),
        .in2(RESULT_ALU_XOR),
        .in3(RESULT_ALU_SLL),
        .in4(RESULT_ALU_SRL),
        .in5(RESULT_ALU_SRA),
        .in6(RESULT_ALU_ADD),
        .in7(RESULT_ALU_SUB),
        .in8(RESULT_ALU_SLT),
        .in9(RESULT_ALU_SLTU),
        .in10(32'b0),
        .in11(32'b0),
        .in12(32'b0),
        .in13(32'b0),
        .in14(32'b0),
        .in15(32'b0),
        .s(control),
        .out(result)
    );

endmodule