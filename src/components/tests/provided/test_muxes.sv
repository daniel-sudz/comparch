`default_nettype none
`timescale 1ns/1ps

module test_muxes;
// Testbench for muxes. Fixes inputs at unique values, then prints the output of each mux so you can compare.

parameter N = 32;

// python: print(", ".join([f"in{i}" for i in range(32)]))
logic [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
wire [N-1:0] out2, out4, out8, out16, out32;
logic [4:0] s;

mux2 #(.N(N)) MUX2 (
  .in0(in0),
  .in1(in1),
  .s(s[0]),
  .out(out2)
);

mux4 #(.N(N)) MUX4 (
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .s(s[1:0]),
  .out(out4)
);

mux8 #(.N(N)) MUX8 (
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .in4(in4),
  .in5(in5),
  .in6(in6),
  .in7(in7),
  .s(s[2:0]),
  .out(out8)
);

mux16 #(.N(N)) MUX16 (
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .in4(in4),
  .in5(in5),
  .in6(in6),
  .in7(in7),
  .in8(in8),
  .in9(in9),
  .in10(in10),
  .in11(in11),
  .in12(in12),
  .in13(in13),
  .in14(in14),
  .in15(in15),
  .s(s[3:0]),
  .out(out16)
);

mux32 #(.N(N)) MUX32 (
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .in4(in4),
  .in5(in5),
  .in6(in6),
  .in7(in7),
  .in8(in8),
  .in9(in9),
  .in10(in10),
  .in11(in11),
  .in12(in12),
  .in13(in13),
  .in14(in14),
  .in15(in15),
  .in16(in16),
  .in17(in17),
  .in18(in18),
  .in19(in19),
  .in20(in20),
  .in21(in21),
  .in22(in22),
  .in23(in23),
  .in24(in24),
  .in25(in25),
  .in26(in26),
  .in27(in27),
  .in28(in28),
  .in29(in29),
  .in30(in30),
  .in31(in31),
  .s(s),
  .out(out32)
);

initial begin
  $dumpfile("muxes.fst");
  $dumpvars;
  // python: print("\n".join([f"in{i} = {(i+1)**2};" for i in range(32)]))
  in0 = 1;
  in1 = 4;
  in2 = 9;
  in3 = 16;
  in4 = 25;
  in5 = 36;
  in6 = 49;
  in7 = 64;
  in8 = 81;
  in9 = 100;
  in10 = 121;
  in11 = 144;
  in12 = 169;
  in13 = 196;
  in14 = 225;
  in15 = 256;
  in16 = 289;
  in17 = 324;
  in18 = 361;
  in19 = 400;
  in20 = 441;
  in21 = 484;
  in22 = 529;
  in23 = 576;
  in24 = 625;
  in25 = 676;
  in26 = 729;
  in27 = 784;
  in28 = 841;
  in29 = 900;
  in30 = 961;
  in31 = 1024;
  $display("%2s | %5s | %5s | %5s | %5s | %5s", "s", "mux2", "mux4", "mux8", "mux16", "mux32");
  for(integer i=0; i< 32; i = i + 1) begin
    s = i[4:0];
    #10;
    $display("%2d | %5d | %5d | %5d | %5d | %5d", s, out2, out4, out8, out16, out32);
  end

  $finish;
end

endmodule