/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic enabled;

    logic in_1_to_2;
    logic [1:0] out_1_to_2;

    logic [1:0] in_2_to_4;
    logic [3:0] out_2_to_4;

    decoder_1_to_2 d1to2(.in(in_1_to_2), .ena(enabled), .out(out_1_to_2));
    decoder_2_to_4 d2to4(.in(in_2_to_4), .ena(enabled), .out(out_2_to_4));


    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin
        for(int test_cases = 0; test_cases < 100; test_cases++) begin
            for(int is_enabled = 0; is_enabled <= 1; is_enabled++) begin
            /* Seed random input to the decoder */
            in_1_to_2 = $urandom();
            in_2_to_4 = $urandom();
            
            /* Set the enabled state */
            enabled = is_enabled[0];

            /* Wait for hardware */ 
            #100;

            /* Test 1-to-2 decoder */
            print_break();
             $display("[1-to-2 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d]", is_enabled, in_1_to_2, out_1_to_2);
             if(is_enabled == 0) begin
                assert(out_1_to_2 == 0) else $fatal;
             end else begin
                assert(out_1_to_2 == (1 << in_1_to_2)) else $fatal;
             end
            print_break();

            /* Test 2-to-4 decoder */
            print_break();
             $display("[2-to-4 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d]", is_enabled, in_2_to_4, out_2_to_4);
             if(is_enabled == 0) begin
                assert(out_1_to_2 == 0) else $fatal;
             end else begin
                assert(out_2_to_4 == (1 << in_2_to_4)) else $fatal;
             end
            print_break();
            

        
            end
        
        $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule