
/* Implements a standard 3-8 decoder 
 *      .ena -> whether the module is enabled or not
 *      .in -> the 3-bit input to the decoder
 *
 *      .out -> the 8-bit output to the decoder
 */     
module decoder_3_to_8(ena, in, out);

    
    /* ----- Inputs  ----- */
    input logic ena; 
    input [2:0] in;

    /* ----- Outputs  ----- */
    output [7:0] out;

    /* ----- Design  ----- */
    decoder_2_to_4 dec1(.ena(ena & ~in[2]), .in(in[1:0]), .out(out[3:0]));
    decoder_2_to_4 dec2(.ena(ena & in[2]), .in(in[1:0]), .out(out[7:4]));

endmodule