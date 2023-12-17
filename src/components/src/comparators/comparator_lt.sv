`timescale 1ns/1ps
`default_nettype none

/*  ----- Implementation Constraints  -----
 *  Using only *structural* combinational logic (or instantiated modules that 
 *  only consist of structural combination logic), make a module that outputs 
 *  high if a < b.
 *
 *  If you use other modules, make sure to update the sources in the Makefile 
 *  appropriately! 
*/

module comparator_lt(a, b, out);

    parameter N = 32;

     /* ----- Inputs  ----- */
    input wire signed [N-1:0] a, b;

    /* ----- Outputs  ----- */
    output logic out;


    /* ----------- Wires ----------- */
    wire a_eq_b;
    logic b_already_bigger [N-1:0];
    logic ok [N-1:0];


    /* ----- Design  ----- */
    comparator_eq check_eq(.a(a), .b(b), .out(a_eq_b));

    /* Base case */
    assign b_already_bigger[N-1] = (~b[N-1] & a[N-1]);
    assign ok[N-1] = (a[N-1] | ~b[N-1]);

    /* Compare bit-by-bit, carrying through the previous position's bit equality check */
    genvar i;
    generate 
        for(i=N-2;i>=0;i--) begin
            assign b_already_bigger[i] = b_already_bigger[i+1] | (b[i] & ~a[i]);
            assign ok[i] = ok[i+1] & (b_already_bigger[i] | (~a[i] | b[i]));
        end
    endgenerate

    /* First position of ok holds the entire less than or equal check */
    assign out = (ok[0] & ~a_eq_b);


endmodule
