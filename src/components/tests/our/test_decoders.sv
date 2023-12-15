/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic enabled;

    logic in_1_to_2;
    logic [1:0] out_1_to_2;

    logic [1:0] in_2_to_4;
    logic [3:0] out_2_to_4;

    logic [2:0] in_3_to_8;
    logic [7:0] out_3_to_8;

    logic [3:0] in_4_to_16;
    logic [15:0] out_4_to_16;

    decoder_1_to_2 d1to2(.in(in_1_to_2), .ena(enabled), .out(out_1_to_2));
    decoder_2_to_4 d2to4(.in(in_2_to_4), .ena(enabled), .out(out_2_to_4));
    decoder_3_to_8 d3to8(.in(in_3_to_8), .ena(enabled), .out(out_3_to_8));
    decoder_4_to_16 d4to16(.in(in_4_to_16), .ena(enabled), .out(out_4_to_16));



    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin
        for(int test_cases = 0; test_cases < 100000; test_cases++) begin
            for(int is_enabled = 0; is_enabled <= 1; is_enabled++) begin
            /* Seed random input to the decoder */
            in_1_to_2 = $urandom();
            in_2_to_4 = $urandom();
            in_3_to_8 = $urandom();
            in_4_to_16 = $urandom();
            
            /* Set the enabled state */
            enabled = is_enabled[0];

            /* Wait for hardware */ 
            #100;

            /* Test 1-to-2 decoder */
            print_break();
             $display("[1-to-2 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d] [out_exp_if_ena: %0d]", is_enabled, in_1_to_2, out_1_to_2, (1 << in_1_to_2));
             if(is_enabled == 0) begin
                assert(out_1_to_2 == 0) else $fatal;
             end else begin
                assert(out_1_to_2 == (1 << in_1_to_2)) else $fatal;
             end
            print_break();

            /* Test 2-to-4 decoder */
            print_break();
             $display("[2-to-4 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d] [out_exp_if_ena: %0d]", is_enabled, in_2_to_4, out_2_to_4, (1 << in_2_to_4) );
             if(is_enabled == 0) begin
                assert(out_2_to_4 == 0) else $fatal;
             end else begin
                assert(out_2_to_4 == (1 << in_2_to_4)) else $fatal;
             end
            print_break();
            
            /* Test 3-to-8 decoder */
            print_break();
             $display("[3-to-8 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d] [out_exp_if_ena: %0d]", is_enabled, in_3_to_8, out_3_to_8, (1 << in_3_to_8));
             if(is_enabled == 0) begin
                assert(out_3_to_8 == 0) else $fatal;
             end else begin
                assert(out_3_to_8 == (1 << in_3_to_8)) else $fatal;
             end
            print_break();


            /* Test 4-to-16 decoder */
            print_break();
             $display("[4-to-16 decoder test]: [is_enabled: %0d] [in: %0d] [out: %0d] [out_exp_if_ena: %0d]", is_enabled, in_4_to_16, out_4_to_16, (1 << in_4_to_16));
             if(is_enabled == 0) begin
                assert(out_4_to_16 == 0) else $fatal;
             end else begin
                assert(out_4_to_16 == (1 << in_4_to_16)) else $fatal;
             end
            print_break();

            end
        
        $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule