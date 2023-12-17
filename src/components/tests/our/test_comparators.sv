`timescale 1ns/1ps
`default_nettype none

/* Test comparators */

module test_comparators ();

    parameter N = 32;

    logic [N-1:0] input_a;
    logic [N-1:0] input_b;

    logic compare_eq_out;
    logic expected_compare_eq_out;

    comparator_eq ceq(.a(input_a), .b(input_b), .out(compare_eq_out));



    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin
        for(int test_cases=0; test_cases<1000; test_cases++) begin
            /* Seed random input */

            /* Test compare_eq */
            input_a = $urandom();
            input_b = $urandom();
            expected_compare_eq_out = (input_a == input_b);
            #10;
            $display("[compare_eq]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_eq_out, expected_compare_eq_out);
            assert(compare_eq_out == (input_a == input_b)) else $fatal;
            
            input_a = $urandom();
            input_b = input_a;
            expected_compare_eq_out = (input_a == input_b);
            #10;
            $display("[compare_eq]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_eq_out, expected_compare_eq_out);
            assert(compare_eq_out == (input_a == input_b)) else $fatal;
            
            $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule