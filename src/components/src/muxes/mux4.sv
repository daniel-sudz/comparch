
/* Design of 4-1 mux using binary module pattern */
module mux4(in_0, in_1, in_2, in_3, s, out);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in_0, in_1, in_2, in_3;
    input wire [1:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux2 block_1(in_0, in_2, s[1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux2 block_2(in_1, in_3, s[1], block_2_out);

    logic [N-1:0] block_3_out ;
    mux2 block_3(block_1_out, block_2_out, s[0], out);

endmodule