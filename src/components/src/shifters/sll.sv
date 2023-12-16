`timescale 1ns/1ps
`default_nettype none

module sll(in, shamt, out);

    parameter N=32;

    /* ----- Inputs  ----- */
    input wire [N-1:0] in;
    input wire [$clog2(N)-1:0] shamt;

    /* ----- Outputs  ----- */
    output wire [N-1:0] out;

    /* Creates a sll shift selector by amt bits */
    `define ssl_n(amt) \
        {in[N-1-amt: 0],{``amt{1'b0}}}

     /* -----  Submodules -----  */ 

     /* Select between every possible shift combination using mux */
    mux32 mux32_shift_selector(
        .in0(`ssl_n(0)),
        .in1(`ssl_n(1)),
        .in2(`ssl_n(2)),
        .in3(`ssl_n(3)),
        .in4(`ssl_n(4)),
        .in5(`ssl_n(5)),
        .in6(`ssl_n(6)),
        .in7(`ssl_n(7)),
        .in8(`ssl_n(8)),
        .in9(`ssl_n(9)),
        .in10(`ssl_n(10)),
        .in11(`ssl_n(11)),
        .in12(`ssl_n(12)),
        .in13(`ssl_n(13)),
        .in14(`ssl_n(14)),
        .in15(`ssl_n(15)),
        .in16(`ssl_n(16)),
        .in17(`ssl_n(17)),
        .in18(`ssl_n(18)),
        .in19(`ssl_n(19)),
        .in20(`ssl_n(20)),
        .in21(`ssl_n(21)),
        .in22(`ssl_n(22)),
        .in23(`ssl_n(23)),
        .in24(`ssl_n(24)),
        .in25(`ssl_n(25)),
        .in26(`ssl_n(26)),
        .in27(`ssl_n(27)),
        .in28(`ssl_n(28)),
        .in29(`ssl_n(29)),
        .in30(`ssl_n(30)),
        .in31(`ssl_n(31)),
        .s(shamt),
        .out(out)
    );

endmodule