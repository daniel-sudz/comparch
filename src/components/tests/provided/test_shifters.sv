`timescale 1ns/1ps
`default_nettype none
module test_sll;

parameter N = 32;

int errors = 0;

logic [N-1:0] in;
logic [$clog2(N)-1:0] shamt;
wire  [N-1:0] sll, srl, sra;

// SystemVerilog's BEHAVIORAL rules around signed entities might seem tricky, but the short version is that if you don't call a bus signed, it's assumed unsigned (for backwards compatability). That means if you use a signed operator (like <<< aka SRA)  the inputs should both be signed! A common trick is to redefine any input nets as follows. Note that if you do a fully STRUCTURAL approach this issue won't even come up.
logic signed [N-1:0] signed_in;
always_comb signed_in = in; 

sll #(.N(N)) SLL(.in(in), .shamt(shamt), .out(sll));
srl #(.N(N)) SRL(.in(in), .shamt(shamt), .out(srl));
sra #(.N(N)) SRA(.in(in), .shamt(shamt), .out(sra));


logic [N-1:0] correct_sll, correct_srl;
logic signed [N-1:0] correct_sra;
always_comb begin : behavioural_solution_logic
  correct_sll = in << shamt;
  correct_srl = in >> shamt;
  correct_sra = signed_in >>> shamt;
end

task print_io;
  $display("%b <<  %d = %b (%b)", in, shamt, sll, correct_sll);
  $display("%b >>  %d = %b (%b)", in, shamt, srl, correct_srl);
  $display("%b >>> %d = %b (%b)", in, shamt, sra, correct_sra);
  $display();
endtask

integer tests_run = 0;
initial begin
  $dumpfile("shifters.fst");
  $dumpvars;

  in = -1;
  shamt = 0;
  
  $display("Specific interesting tests.");
  in = -1; // shorthand for setting in to all ones
  
  for(int i = 0; i < 32; i = i + 1) begin
    tests_run = tests_run + 1;
    shamt = i[$clog2(N)-1:0];
    #10 print_io();
  end
  
  $display("Random testing.");
  for (int i = 0; i < 100; i = i + 1) begin : random_testing
    tests_run = tests_run + 1;
    in = $random();
    shamt = $random();
    #10;
  end
  if(errors === 0) begin
    $display("-------------------------------------------------------------------");
    $display("-- SUCCESS...  probably?                                         --");
    $display("-- You completed %d/(large number here)  tests.", tests_run);
    $display("-- How confident are you really? How can you prove that?         --");
    $display("--                                                               --");
    $display("-------------------------------------------------------------------");
  end else begin
    $display("\n");
    $display("---------------------------------------------------------------");
    $display("-- FAILURE                                                   --");
    $display("--  %3d errors found, try again, I believe in you!!!", errors);
    $display("---------------------------------------------------------------");    
  end
  $finish;
end

int MAX_ERRORS = 25;
always @(in or shamt) begin
  #5;
  assert(sll === correct_sll) else begin
    print_io;
    $display("ERROR: sll(%b,%d) should be %b, is %b", in, shamt, correct_sll, sll);
    errors = errors + 1;
  end
  assert(srl === correct_srl) else begin
    print_io;
    $display("ERROR: srl(%b,%d) should be %b, is %b", in, shamt, correct_srl, srl);
    errors = errors + 1;
  end
  assert(sra === correct_sra) else begin
    print_io;
    $display("ERROR: sra(%b,%d) should be %b, is %b", in, shamt,  correct_sra, sra);
    errors = errors + 1;
  end
  if (errors > MAX_ERRORS) begin
    $display("Quitting early, there are at least %d errors.", MAX_ERRORS);
    $finish;
  end
end

endmodule