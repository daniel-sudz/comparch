
/* Implements a standard 1-2 decoder 
 *      .ena -> whether the module is enabled or not
 *      .in -> the 1-bit input to the decoder
 *
 *      .out -> the 2-bit output to the decoder
 */     
module decoder_1_to_2(ena, in, out);

    
    /* ----- Inputs  ----- */
    input logic ena; 
    input logic in;

    /* ----- Outputs  ----- */
    output logic [1:0] out;

    /* ----- Design  ----- */
    always_comb out[0] = ~in & ena;
    always_comb out[1] = in & ena;

endmodule