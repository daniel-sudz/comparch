
/* Implements a standard 2-4 decoder 
 *      .ena -> whether the module is enabled or not
 *      .in -> the 2-bit input to the decoder
 *
 *      .out -> the 4-bit output to the decoder
 */     
module decoder_2_to_4(ena, in, out);

    
    /* ----- Inputs  ----- */
    input logic ena; 
    input [1:0] in;

    /* ----- Outputs  ----- */
    output [3:0] out;

    /* ----- Design  ----- */
    decoder_1_to_2 dec1(.ena(ena & ~in[1]), .in(in[0]), .out(out[1:0]));
    decoder_1_to_2 dec2(.ena(ena & in[1]), .in(in[0]), .out(out[3:2]));

endmodule