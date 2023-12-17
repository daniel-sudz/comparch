`timescale 1ns/1ps
`default_nettype none

/*  ----- Implementation Constraints  -----
 *  Using only *structural* combinational logic (or instantiated modules that 
 *  only consist of structural combination logic), make a module that outputs 
 *  high if a == b.
 *
 *  If you use other modules, make sure to update the sources in the Makefile 
 *  appropriately! 
*/


/* Implements a standard equality comparator
 *      .a -> the n-bit first input
 *      .b -> the n-bit second input
 *
 *      .out -> if a is strictly equal to b
 */   
module comparator_eq(a, b, out);

    parameter N = 32;

    /* ----- Inputs  ----- */
    input wire signed [N-1:0] a, b;

    /* ----- Outputs  ----- */
    output logic out;

    /* ----------- Wires ----------- */
    logic eq_partials [N-1:0];


    /* ----- Design  ----- */
    assign out = 0;

    /* Base case */
    assign eq_partials[0] = ~(a[0] ^ b[0]);

    /* Compare bit-by-bit, carrying through the previous position's bit equality check */
    genvar i;
    generate 
        for(i=1;i<N;i++) begin
            assign eq_partials[i] = eq_partials[i - 1] & (~(a[i] ^ b[i]));
        end
    endgenerate

    /* Last position of eq_partials holds the entire equality check */
    assign out = eq_partials[N-1];

endmodule
