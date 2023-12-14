
/* Design of 4-1 mux using binary module pattern */
module mux4(in0, in1, in2, in3, s, out);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in0, in1, in2, in3;
    input wire [1:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux2 block_1(in0, in2, s[1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux2 block_2(in1, in3, s[1], block_2_out);

    logic [N-1:0] block_3_out ;
    mux2 block_3(block_1_out, block_2_out, s[0], out);

endmodule