
/* Design of 32-1 mux using binary module pattern */
module mux32(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31;
    input wire [4:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux16 block_1(in_0, in_2, in_4, in_6, in_8, in_10, in_12, in_14, in_16, in_18, in_20, in_22, in_24, in_26, in_28, in_30, s[4:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux16 block_2(in_1, in_3, in_5, in_7, in_9, in_11, in_13, in_15, in_17, in_19, in_21, in_23, in_25, in_27, in_29, in_31, s[4:1], block_2_out);

    mux2 block_3(block_1_out, block_2_out, s[0], out);

endmodule