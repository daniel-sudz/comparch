
/* Design of 16-1 mux using binary module pattern */
module mux16(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, s, out);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
    input wire [3:0] s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux8 block_1(in0, in2, in4, in6, in8, in10, in12, in14, s[3:1], block_1_out);

    logic [N-1:0] block_2_out ;
    mux8 block_2(in1, in3, in5, in7, in9, in11, in13, in15, s[3:1], block_2_out);

    mux2 block_3(block_1_out, block_2_out, s[0], out);

endmodule