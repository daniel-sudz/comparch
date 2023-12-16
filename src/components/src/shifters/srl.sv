`timescale 1ns/1ps
`default_nettype none

/* Implements a standard srl shifter (shift right logical)
 *      .in -> the 32-bit input to the shifter
 *      .shamt -> how much to shift to the right
 *
 *      .out -> the shifted output
 */   
module srl(in, shamt, out);

    parameter N=32;

    /* ----- Inputs  ----- */
    input wire [N-1:0] in;
    input wire [$clog2(N)-1:0] shamt;

    /* ----- Outputs  ----- */
    output wire [N-1:0] out;

    /* Creates a srl shift selector by amt bits */
    `define srl_n(amt) \
        {{``amt{1'b0}}, in[N-1: amt]}

     /* -----  Submodules -----  */ 

     /* Select between every possible shift combination using mux */
    mux32 mux32_shift_selector(
        .in0(`srl_n(0)),
        .in1(`srl_n(1)),
        .in2(`srl_n(2)),
        .in3(`srl_n(3)),
        .in4(`srl_n(4)),
        .in5(`srl_n(5)),
        .in6(`srl_n(6)),
        .in7(`srl_n(7)),
        .in8(`srl_n(8)),
        .in9(`srl_n(9)),
        .in10(`srl_n(10)),
        .in11(`srl_n(11)),
        .in12(`srl_n(12)),
        .in13(`srl_n(13)),
        .in14(`srl_n(14)),
        .in15(`srl_n(15)),
        .in16(`srl_n(16)),
        .in17(`srl_n(17)),
        .in18(`srl_n(18)),
        .in19(`srl_n(19)),
        .in20(`srl_n(20)),
        .in21(`srl_n(21)),
        .in22(`srl_n(22)),
        .in23(`srl_n(23)),
        .in24(`srl_n(24)),
        .in25(`srl_n(25)),
        .in26(`srl_n(26)),
        .in27(`srl_n(27)),
        .in28(`srl_n(28)),
        .in29(`srl_n(29)),
        .in30(`srl_n(30)),
        .in31(`srl_n(31)),
        .s(shamt),
        .out(out)
    );

endmodule