/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic [N-1:0] shift_in;
    logic [$clog2(N)-1:0] shift_amount_in;
    
    logic [N-1:0] shift_out_sll;


    sll sll_shifter(.in(shift_in), .shamt(shift_amount_in), .out(shift_out_sll));


    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin

        for(integer test_cases=0; test_cases<1000; test_cases++) begin
            for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                /* Seed Inputs */
                shift_in = $urandom();
                #100;

                /* Test sll shifter */
                print_break();
                for(integer shift_amount=0; shift_amount<N; shift_amount++) begin
                    shift_amount_in = shift_amount;
                    #100;
                    $display("[sll shifter test shamt:%0d]: [shift_in: %0d] [shift_out: %0d]", shift_amount_in, shift_in, shift_out_sll);
                    assert((shift_in << shift_amount_in) == shift_out_sll) else $fatal;
                end
                print_break();


                end
            $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule