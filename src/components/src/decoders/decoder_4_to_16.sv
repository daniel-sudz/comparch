`timescale 1ns/1ps
`default_nettype none

/* Implements a standard 4-16 decoder 
 *      .ena -> whether the module is enabled or not
 *      .in -> the 4-bit input to the decoder
 *
 *      .out -> the 16-bit output to the decoder
 */     
module decoder_4_to_16(ena, in, out);

    
    /* ----- Inputs  ----- */
    input logic ena; 
    input [3:0] in;

    /* ----- Outputs  ----- */
    output [15:0] out;

    /* ----- Design  ----- */
    decoder_3_to_8 dec1(.ena(ena & ~in[3]), .in(in[2:0]), .out(out[7:0]));
    decoder_3_to_8 dec2(.ena(ena & in[3]), .in(in[2:0]), .out(out[15:8]));

endmodule