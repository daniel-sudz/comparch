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

    /* ----- Output Overflow Cases  ----- */
    logic RESULT_ADD_OVERFLOW;
    logic RESULT_SUB_OVERFLOW;

    /* ----- [AND] Operation Result  ----- */
    assign RESULT_ALU_AND = a & b;

    /* ----- [OR] Operation Result  ----- */
    assign RESULT_ALU_OR = a | b;

    /* ----- [XOR] Operation Result  ----- */
    assign RESULT_ALU_XOR = a ^ b;

    /* ----- [SHIFTERS] Helper States  ----- */
    /* Add helper states for when b >= $clog2(N) which overflow the shifters that we implemented*/
    logic [N:0] shift_overflow;
    assign shift_overflow[N] = 0;

    generate
        genvar i;
        for(i=N-1;i>=$clog2(N);i--) begin
            assign shift_overflow[i] = shift_overflow[i+1] | b[i];
        end
    endgenerate

    logic [N-1:0] shift_overflow_mask;
    assign shift_overflow_mask = {N{shift_overflow[$clog2(N)]}};

    /* ----- [SLL] Operation Result  ----- */
    logic [N-1:0] NO_OVERFLOW_RESULT_ALU_SLL;
    sll #(N) sll_alu_shifter(.in(a), .shamt(b[$clog2(N)-1:0]), .out(NO_OVERFLOW_RESULT_ALU_SLL));
    assign RESULT_ALU_SLL = NO_OVERFLOW_RESULT_ALU_SLL & (~shift_overflow_mask);

    /* ----- [SRL] Operation Result  ----- */
    logic [N-1:0] NO_OVERFLOW_RESULT_ALU_SRL;
    srl #(N) srl_alu_shifter(.in(a), .shamt(b[$clog2(N)-1:0]), .out(NO_OVERFLOW_RESULT_ALU_SRL));
    assign RESULT_ALU_SRL = NO_OVERFLOW_RESULT_ALU_SRL & (~shift_overflow_mask);

    /* ----- [Equal] Operation Result   ----- */
    comparator_eq eqcmp(.a(a), .b(b), .out(equal));

    /* ----- [Zero] Operation Result   ----- */
    comparator_eq zerocmp(.a(result), .b(32'b0), .out(zero));
    

    /* ----- Mux Operation Results  ----- */
    mux16 result_mux(
        .in0(32'b0),
        .in1(RESULT_ALU_AND),
        .in2(RESULT_ALU_OR),
        .in3(RESULT_ALU_XOR),
        .in4(32'b0),
        .in5(RESULT_ALU_SLL),
        .in6(32'b0),
        .in7(32'b0),
        .in8(32'b0),
        .in9(32'b0),
        .in10(32'b0),
        .in11(32'b0),
        .in12(32'b0),
        .in13(32'b0),
        .in14(32'b0),
        .in15(32'b0),
        .s(control),
        .out(result)
    );

    /* ----- Mux Overflow Results  ----- */
    mux16 #(1) overflow_mux(
        .in0(1'b0),
        .in1(1'b0),
        .in2(1'b0),
        .in3(1'b0),
        .in4(1'b0),
        .in5(1'b0),
        .in6(1'b0),
        .in7(RESULT_ADD_OVERFLOW),
        .in8(RESULT_SUB_OVERFLOW),
        .in9(1'b0),
        .in10(1'b0),
        .in11(1'b0),
        .in12(1'b0),
        .in13(1'b0),
        .in14(1'b0),
        .in15(1'b0),
        .s(control),
        .out(overflow)
    );

endmodule