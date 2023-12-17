`timescale 1ns/1ps
`default_nettype none

/* Design of 8-1 mux using binary module pattern */
module mux8(in0, in1, in2, in3, in4, in5, in6, in7, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
    input wire [2:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux4 block_1(in0, in2, in4, in6, s[2:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux4 block_2(in1, in3, in5, in7, s[2:1], block_2_out);

    mux2 block_3(block_1_out, block_2_out, s[0], out );

endmodule