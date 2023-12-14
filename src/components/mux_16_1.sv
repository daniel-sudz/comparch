
/* Design of 16-1 mux using binary module pattern */
module mux_16_1(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15;
    input wire [3:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux_8_1 block_1(in_0, in_2, in_4, in_6, in_8, in_10, in_12, in_14, s[3:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux_8_1 block_2(in_1, in_3, in_5, in_7, in_9, in_11, in_13, in_15, s[3:1], block_2_out);

    mux_2_1 block_3(block_1_out, block_2_out, s[0], out);

endmodule