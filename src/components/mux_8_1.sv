
/* Design of 8-1 mux using binary module pattern */
module mux_8_1(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7;
    input wire [2:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux_4_1 block_1(in_0, in_2, in_4, in_6, s[2:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux_4_1 block_2(in_1, in_3, in_5, in_7, s[2:1], block_2_out);

    mux_2_1 block_3(block_1_out, block_2_out, s[0], out );

endmodule