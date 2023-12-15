`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  logic ena;
  logic [4:0] in;
  wire [1:0] out2;
  wire [3:0] out4;
  wire [7:0] out8;
  wire [15:0] out16;
  wire [31:0] out32;

  decoder_1_to_2 DECODER_1_2  (.ena(ena), .in(in[0]  ), .out(out2));

  decoder_2_to_4 DECODER_2_4  (.ena(ena), .in(in[1:0]), .out(out4));
  
  decoder_3_to_8 DECODER_3_8  (.ena(ena), .in(in[2:0]), .out(out8));
  
  decoder_4_to_16 DECODER_4_16(.ena(ena), .in(in[3:0]), .out(out16));

  decoder_5_to_32 DECODER_5_32(.ena(ena), .in(in[4:0]), .out(out32));

  initial begin
    // Collect waveforms.
    $dumpfile("decoders.fst");
    $dumpvars;
    
    // Test with enable first. 
    ena = 1;
    $display("~~~ only one output should be high per decoder ~~~");
    $display("%4s %5s | 0x%08h 0x%08h 0x%08h 0x%08h 0x%08h", "ena", "in", "1:2", "2:4", "3:8", "4:16", "5:32");
    for (int i = 0; i < 32; i = i + 1) begin
      in = i[4:0];
      #10;
      $display(" %8b %8b | 0x%08h 0x%08h 0x%08h 0x%08h 0x%08h", ena, in, out2, out4, out8, out16, out32);
    end

    // Ensure that with enable low no outputs are high.
    $display("~~~ all outputs should be low ~~~");
    $display("%4s %5s | 0x%08h 0x%08h 0x%08h 0x%08h 0x%08h", "ena", "in", "1:2", "2:4", "3:8", "4:16", "5:32");
    ena = 0;
    for (int i = 0; i < 32; i = i + 1) begin
      in = i[4:0];
      #10;
      $display(" %8b %8b | 0x%08h 0x%08h 0x%08h 0x%08h 0x%08h", ena, in, out2, out4, out8, out16, out32);
    end
        
    $finish;      
	end

endmodule