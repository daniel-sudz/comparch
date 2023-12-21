`timescale 1ns/1ps
`default_nettype none

/* Implements a standard n-bit adder
 *      .a -> n-bits from first number to add
 *      .b -> n-bits from second number to add
 *      .c_in -> 1 bit carry in to add
 *
 *      .sum -> n-bit summation of a, b, and carry
 *      .c_out -> 1 bit carry of the output
 */ 

module adder_n(a, b, c_in, sum, c_out);

    parameter N=32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] a;
    input wire [N-1:0] b;
    input wire c_in;

    /* ----- Outputs  ----- */
    output logic [N-1:0] sum;
    output logic c_out;

    /* ----- Wires  ----- */
    logic [N:0] carries;

    /* ----- Design  ----- */
    assign carries[0] = c_in;

    /* Chain up our 1-bit adders */
    genvar i; 
    generate
        for(i=0;i<N;i++) begin
            adder_1 RIPPLE(
                .a(a[i]), 
                .b(b[i]), 
                .c_in(carries[i]), 
                .sum(sum[i]),
                .c_out(carries[i+1]));
        end
    endgenerate

    /* Last bit is the carry bit for the entire summation */
    assign c_out = carries[N];

endmodule