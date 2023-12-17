`timescale 1ns/1ps
`default_nettype none
module test_comparators;

parameter N = 32;

int errors = 0;

logic signed [N-1:0] a, b; // Adding the 'signed' keyword here makes the behavioural logic compute a signed slt.
wire equals, less_than;

comparator_eq #(.N(N)) UUT_EQ(.a(a), .b(b), .out(equals));
comparator_lt #(.N(N)) UUT_LT(.a(a), .b(b), .out(less_than));


/*
It's impossible to exhaustively test all inputs as N gets larger, there are just
too many possibilities. Instead we can use a combination of testing interesting 
specified edge cases (e.g. adding by zero, seeing what happens on an overflow)
and some random testing! SystemVerilog has a lot of capabilities for this 
that we'll explore in further testbenches.
  1) the tester: sets inputs
  2) checker(s): verifies that the functionality of our HDL is correct
                 using higher level programming constructs that don't
                 necessarily translate to real hardware.
*/


// Some behavioural comb. logic that computes correct values. 
// This is actually synthesizable, but we are trying to learn here.
logic correct_equals, correct_less_than;

always_comb begin : behavioural_solution_logic
  correct_less_than = a < b;
  correct_equals = a == b;
end

// You can make "tasks" in testbenches. Think of them like methods of a class, 
// they have access to the member variables of the module.
task print_io;
  $display("%8h %8h | == %b (%b) | <  %b (%b)", a, b, equals, correct_equals, less_than, correct_less_than);
endtask


// 2) Test cases.
initial begin
  $dumpfile("comparators.fst");
  $dumpvars;
  
  $display("Specific interesting tests.");
  $display("a        b        | == uut (correct) | < uut (correct)");
  a = 0;
  b = 0;
  #1 print_io();
  
  a = -1;
  b = 1;
  #1 print_io();

  a = 38273;
  b = 38273;
  #1 print_io();

  // Add more interesting tests here!
  // <<<SOLUTION
  // Overflow case with carry in.
  a = (1 << (N-1)) -1;
  b = (1 << (N-1));
  #1 print_io();

  // largest negative number compared with 1 (should force an overflow)
  a = {1'b1, {(N-1){1'b0}}};
  b = 1;
  #1 print_io();

  // zero and largest positive number
  a = 0;
  b = {1'b0, {(N-1){1'b1}}};
  #1 print_io();

  // most negative number and most positive number
  a = {1'b1, {(N-1){1'b0}}};
  b = {1'b0, {(N-1){1'b1}}};
  #1 print_io();
  a = {1'b0, {(N-1){1'b1}}};
  b = {1'b1, {(N-1){1'b0}}};
  #1 print_io();
  // SOLUTION>>>

  
  $display("Random testing.");
  for (int i = 0; i < 10; i = i + 1) begin : random_testing
    a = $random();
    b = $random();
    #1 print_io();
  end
  if (errors !== 0) begin
    $display("---------------------------------------------------------------");
    $display("-- FAILURE                                                   --");
    $display("---------------------------------------------------------------");
    $display(" %d failures found, try again!", errors);
  end else begin
    $display("---------------------------------------------------------------");
    $display("-- SUCCESS                                                   --");
    $display("---------------------------------------------------------------");
  end
  $finish;
end

// Note: the triple === (corresponding !==) check 4-state (e.g. 0,1,x,z) values.
//       It's best practice to use these for checkers!
always @(a or b) begin
  #1;
  assert(equals === correct_equals) else begin
    $display("@%t:: ERROR :: compare_eq should be %b, is %b", $time, correct_equals, equals);
    errors = errors + 1;
  end
  assert(less_than === correct_less_than) else begin
    $display("@%t:: ERROR :: compare_lt should be %b, is %b", $time, correct_less_than, less_than);
    errors = errors + 1;
  end
end

endmodule