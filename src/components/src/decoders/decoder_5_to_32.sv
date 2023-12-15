
/* Implements a standard 5-32 decoder 
 *      .ena -> whether the module is enabled or not
 *      .in -> the 5-bit input to the decoder
 *
 *      .out -> the 32-bit output to the decoder
 */     
module decoder_5_to_32(ena, in, out);

    
    /* ----- Inputs  ----- */
    input logic ena; 
    input [4:0] in;

    /* ----- Outputs  ----- */
    output [31:0] out;

    /* ----- Design  ----- */
    decoder_4_to_16 dec1(.ena(ena & ~in[4]), .in(in[3:0]), .out(out[15:0]));
    decoder_4_to_16 dec2(.ena(ena & in[4]), .in(in[3:0]), .out(out[31:16]));

endmodule