`timescale 1ns/1ps
`default_nettype none

/* Test shifters */

module test_shifters;

    parameter N = 32;

    logic [N-1:0] shift_in;
    logic signed [N-1:0] shift_in_signed;
    logic [$clog2(N)-1:0] shift_amount_in;
    
    logic [N-1:0] shift_out_sll;
    logic [N-1:0] shift_out_srl;
    logic signed [N-1:0] shift_out_sra;

    logic signed [N-1:0] expected_sra_out;

    sll sll_shifter(.in(shift_in), .shamt(shift_amount_in), .out(shift_out_sll));
    srl srl_shifter(.in(shift_in), .shamt(shift_amount_in), .out(shift_out_srl));
    sra sra_shifter(.in(shift_in), .shamt(shift_amount_in), .out(shift_out_sra));


    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
    endfunction

    initial begin
        $dumpfile("shifters-ours.fst");
        $dumpvars;

        for(integer test_cases=0; test_cases<1000; test_cases++) begin
            for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                /* Seed Inputs */
                shift_in = $urandom();
                shift_in_signed = shift_in;
                #10;

                /* Test sll shifter */
                print_break();
                for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                    shift_amount_in = shift_amount;
                    #10;
                    $display("[sll shifter test shamt:%0d]: [shift_in: %0d] [shift_out: %0d]", shift_amount_in, shift_in, shift_out_sll);
                    assert((shift_in << shift_amount_in) == shift_out_sll) else $fatal;
                end
                print_break();

                /* Test srl shifter */
                print_break();
                for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                    shift_amount_in = shift_amount;
                    #10;
                    $display("[srl shifter test shamt:%0d]: [shift_in: %0d] [shift_out: %0d]", shift_amount_in, shift_in, shift_out_srl);
                    assert((shift_in >> shift_amount_in) == shift_out_srl) else $fatal;
                end
                print_break();

                /* Test sra shifter */
                print_break();
                for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                    shift_amount_in = shift_amount;
                    expected_sra_out = (shift_in_signed >>> shift_amount_in);
                    #10;
                    $display("[sra shifter test shamt:%0d]: [shift_in_signed: %0d] [shift_out: %0d] [expected: %0d]", shift_amount_in, shift_in_signed, shift_out_sra, expected_sra_out);
                    assert((shift_in_signed >>> shift_amount_in) == shift_out_sra) else $fatal;
                end
                print_break();


                end
            $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule