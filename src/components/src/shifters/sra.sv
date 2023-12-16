`timescale 1ns/1ps
`default_nettype none

/* Implements a standard sra shifter (shift right arithmetic)
 *      .in -> the 32-bit input to the shifter
 *      .shamt -> how much to shift to the right
 *
 *      .out -> the shifted output
 */   
module sra(in, shamt, out);

    parameter N=32;

    /* ----- Inputs  ----- */
    input wire [N-1:0] in;
    input wire [$clog2(N)-1:0] shamt;

    /* ----- Outputs  ----- */
    output wire [N-1:0] out;

    /* Creates a srl shift selector by amt bits */
    `define sra_n(amt) \
        {{``(amt){in[N-1]}}, in[N-1: amt]}

     /* -----  Submodules -----  */ 

     /* Select between every possible shift combination using mux */
    mux32 mux32_shift_selector(
        .in0(in),
        .in1(`sra_n(1)),
        .in2(`sra_n(2)),
        .in3(`sra_n(3)),
        .in4(`sra_n(4)),
        .in5(`sra_n(5)),
        .in6(`sra_n(6)),
        .in7(`sra_n(7)),
        .in8(`sra_n(8)),
        .in9(`sra_n(9)),
        .in10(`sra_n(10)),
        .in11(`sra_n(11)),
        .in12(`sra_n(12)),
        .in13(`sra_n(13)),
        .in14(`sra_n(14)),
        .in15(`sra_n(15)),
        .in16(`sra_n(16)),
        .in17(`sra_n(17)),
        .in18(`sra_n(18)),
        .in19(`sra_n(19)),
        .in20(`sra_n(20)),
        .in21(`sra_n(21)),
        .in22(`sra_n(22)),
        .in23(`sra_n(23)),
        .in24(`sra_n(24)),
        .in25(`sra_n(25)),
        .in26(`sra_n(26)),
        .in27(`sra_n(27)),
        .in28(`sra_n(28)),
        .in29(`sra_n(29)),
        .in30(`sra_n(30)),
        .in31(`sra_n(31)),
        .s(shamt),
        .out(out)
    );

endmodule