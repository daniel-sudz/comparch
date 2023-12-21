/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

/* Implements a standard 1 bit adder that we can daisy chain for ripple carry adders
 *      .a -> 1 bit from first number to add
 *      .b -> 1 bit from second number to add
 *      .c_in -> 1 bit carry in to add
 *
 *      .sum -> 1 bit summation of a, b, and carry
 *      .c_out -> 1 bit carry of the output
 */ 

module adder_1(a, b, c_in, sum, c_out);
    
    /* ----- Inputs  ----- */
    input wire a, b, c_in;

    /* ----- Outputs  ----- */
    output logic sum, c_out;

    /* ----- Design  ----- */
    assign sum = a ^ b ^ c_in;                        // summation mod2 is xor
    assign c_out = (a & b) | (a & c_in) | (b & c_in); // carry if at least two inputs set


endmodule