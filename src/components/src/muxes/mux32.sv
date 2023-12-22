`timescale 1ns/1ps
`default_nettype none

/* Design of 32-1 mux using binary module pattern */
module mux32(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
    input wire [4:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux16 #(N) block_1(in0, in2, in4, in6, in8, in10, in12, in14, in16, in18, in20, in22, in24, in26, in28, in30, s[4:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux16 #(N) block_2(in1, in3, in5, in7, in9, in11, in13, in15, in17, in19, in21, in23, in25, in27, in29, in31, s[4:1], block_2_out);

    mux2 #(N) block_3(block_1_out, block_2_out, s[0], out);

endmodule