`timescale 1ns/1ps
`default_nettype none

/* Test comparators */

module test_comparators;

    parameter N = 32;

    logic signed [N-1:0] input_a;
    logic signed [N-1:0] input_b;

    logic compare_eq_out;
    logic expected_compare_eq_out;

    logic compare_lt_out;
    logic expected_compare_lt_out;

    comparator_eq ceq(.a(input_a), .b(input_b), .out(compare_eq_out));
    comparator_lt clt(.a(input_a), .b(input_b), .out(compare_lt_out));


    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin
        $dumpfile("comparators-ours.fst");
        $dumpvars(0, test_comparators);

        for(int test_cases=0; test_cases<10000; test_cases++) begin

            /* Test compare_eq */
            print_break();
            input_a = $urandom();
            input_b = $urandom();
            expected_compare_eq_out = (input_a == input_b);
            #10;
            $display("[compare_eq]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_eq_out, expected_compare_eq_out);
            assert(compare_eq_out == expected_compare_eq_out) else $fatal;
            
            input_a = $urandom();
            input_b = input_a;
            expected_compare_eq_out = (input_a == input_b);
            #10;
            $display("[compare_eq]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_eq_out, expected_compare_eq_out);
            assert(compare_eq_out == expected_compare_eq_out) else $fatal;
            print_break();

            /* Test compare_lt */
            print_break();
            input_a = $urandom();
            input_b = $urandom();
            expected_compare_lt_out = (input_a < input_b);
            #10;
            $display("[compare_lt]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_lt_out, expected_compare_lt_out);
            assert(compare_lt_out == expected_compare_lt_out) else $fatal;
            
            input_a = $urandom();
            input_b = input_a;
            expected_compare_lt_out = (input_a < input_b);
            #10;
            $display("[compare_lt]: [a: %0d], [b: %0d], [out: %0d] [expected_out: %0d]", input_a, input_b, compare_lt_out, expected_compare_lt_out);
            assert(compare_lt_out == expected_compare_lt_out) else $fatal;
            print_break();
            
            $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end

endmodule