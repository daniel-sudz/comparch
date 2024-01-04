`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
    parameter N = 32;
    parameter ACCOUNT_SHIFT_OVERFLOW = 1;
    
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

    /* Options to ignore bits set above 5 which will always result to 0 after shift */
    /* Useful in some cases such as in CPU to more easily parse op codes */
    if(ACCOUNT_SHIFT_OVERFLOW) begin
        assign shift_overflow_mask = {N{shift_overflow[$clog2(N)]}};
    end else begin
        assign shift_overflow_mask = {N{1'b0}};
    end
    
    /* ----- [SLL] Operation Result  ----- */
    logic [N-1:0] NO_OVERFLOW_RESULT_ALU_SLL;
    sll #(N) sll_alu_shifter(.in(a), .shamt(b[$clog2(N)-1:0]), .out(NO_OVERFLOW_RESULT_ALU_SLL));
    assign RESULT_ALU_SLL = NO_OVERFLOW_RESULT_ALU_SLL & (~shift_overflow_mask);

    /* ----- [SRL] Operation Result  ----- */
    logic [N-1:0] NO_OVERFLOW_RESULT_ALU_SRL;
    srl #(N) srl_alu_shifter(.in(a), .shamt(b[$clog2(N)-1:0]), .out(NO_OVERFLOW_RESULT_ALU_SRL));
    assign RESULT_ALU_SRL = NO_OVERFLOW_RESULT_ALU_SRL & (~shift_overflow_mask);

    /* ----- [SRA] Operation Result  ----- */
    logic [N-1:0] NO_OVERFLOW_RESULT_ALU_SRA;
    sra #(N) sra_alu_shifter(.in(a), .shamt(b[$clog2(N)-1:0]), .out(NO_OVERFLOW_RESULT_ALU_SRA));
    assign RESULT_ALU_SRA = NO_OVERFLOW_RESULT_ALU_SRA & (~shift_overflow_mask);

    /* ----- [ADD] Operation Result  ----- */
    logic alu_adder_overflow;
    adder_n #(N) adder_n_alu_add(.a(a), .b(b), .c_in(1'b0), .c_out(alu_adder_overflow), .sum(RESULT_ALU_ADD));
    
    /* Overflow happens when a and b have the same sign which is different from the result sign */
    assign RESULT_ADD_OVERFLOW = (~(a[N-1] ^ b[N-1])) & (a[N-1] ^ RESULT_ALU_ADD[N-1]);

    /* ----- [SUB] Operation Result  ----- */
    logic alu_sub_overflow;
    /* We account for 2's complement by inverting b and passing in 1 to the carry_in https://en.wikipedia.org/wiki/Two%27s_complement */
    adder_n #(N) adder_n_alu_sub(.a(a), .b(~b), .c_in(1'b1), .c_out(alu_sub_overflow), .sum(RESULT_ALU_SUB));
    
    /* Overflow happens when a and b have the same sign which is different from the result sign */
    assign RESULT_SUB_OVERFLOW = (~(a[N-1] ^ (~b[N-1]))) & (a[N-1] ^ RESULT_ALU_SUB[N-1]);
    
    /* ----- [SLT] Operation Result  ----- */
    logic set_less_than_alu_intermediate;
    comparator_lt #(N) set_less_than_alu(.a(a), .b(b), .out(set_less_than_alu_intermediate));
    assign RESULT_ALU_SLT = {31'b0, set_less_than_alu_intermediate};

    /* ----- [SLTU] Operation Result  ----- */
    logic set_less_than_unsigned_alu_intermediate;
    comparator_lt #(N+1) set_less_than_unsigned_alu(.a({1'b0, a}), .b({1'b0, b}), .out(set_less_than_unsigned_alu_intermediate));
    assign RESULT_ALU_SLTU = {31'b0, set_less_than_unsigned_alu_intermediate};


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
        .in6(RESULT_ALU_SRL),
        .in7(RESULT_ALU_SRA),
        .in8(RESULT_ALU_ADD),
        .in9(32'b0),
        .in10(32'b0),
        .in11(32'b0),
        .in12(RESULT_ALU_SUB),
        .in13(RESULT_ALU_SLT),
        .in14(32'b0),
        .in15(RESULT_ALU_SLTU),
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
        .in7(1'b0),
        .in8(RESULT_ADD_OVERFLOW),
        .in9(1'b0),
        .in10(1'b0),
        .in11(1'b0),
        .in12(RESULT_SUB_OVERFLOW),
        .in13(RESULT_SUB_OVERFLOW),
        .in14(1'b0),
        .in15(RESULT_SUB_OVERFLOW),
        .s(control),
        .out(overflow)
    );

endmodule