`timescale 1ns/1ps
`default_nettype none

/* Test comparators */

module test_adders;

    parameter N = 32;

    logic [N-1:0] input_a, input_b, carry_in, sum, expected_sum;
    logic carry_out;

    adder_n #(.N(N)) ADDER(
        .a(input_a), 
        .b(input_b), 
        .c_in(carry_in[0]),
        .sum(sum),
        .c_out(carry_out));

    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin
        $dumpfile("adders-ours.fst");
        $dumpvars(0, test_adders);

        for(int test_cases=0; test_cases<100000; test_cases++) begin

            /* Test adder_n */
            print_break();
            input_a = $urandom();
            input_b = $urandom();
            carry_in = 0;
            carry_in[0] = $urandom();
            expected_sum = input_a + input_b + carry_in;
          
            #10;
            $display("[test_adders]: [a: %0d], [b: %0d], [cin: %0d], [sum: %0d] [expected_sum: %0d]", input_a, input_b, carry_in, sum, expected_sum);
            assert(sum == expected_sum) else $fatal;
        end
        $finish;
    end

endmodule