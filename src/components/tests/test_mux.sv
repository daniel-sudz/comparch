/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic [N-1:0] mux_input [N-1:0];
    
    logic mux_select_1bit;
    logic [1:0] mux_select_2bit;
    logic [2:0] mux_select_3bit;


    wire [N-1:0] mux_output [4:0];

    mux_2_1 mux21_a(
        .input_1(mux_input[0]), 
        .input_2(mux_input[1]), 
        .select(mux_select_1bit), 
        .mux_output(mux_output[0]));

    mux_4_1 mux41_a(
        .input_1(mux_input[0]), 
        .input_2(mux_input[1]), 
        .input_3(mux_input[2]), 
        .input_4(mux_input[3]), 
        .select(mux_select_2bit), 
        .mux_output(mux_output[1]));

    mux_8_1 mux81_a(
        .input_1(mux_input[0]), 
        .input_2(mux_input[1]), 
        .input_3(mux_input[2]), 
        .input_4(mux_input[3]), 
        .input_5(mux_input[4]), 
        .input_6(mux_input[5]), 
        .input_7(mux_input[6]), 
        .input_8(mux_input[7]), 
        .select(mux_select_3bit), 
        .mux_output(mux_output[2]));

    function void print_test_input;
        input string debug_msg;
        input [N-1:0] display_out;
        input [N-1:0] select_in;
        begin
            $write("%s mux input: [", debug_msg);
            for(int i=0;i<32;i++) begin
                $write("%d,", mux_input[i]);
            end
            $display("], mux_select: [%d], mux_output: [%d]", select_in, display_out);
        end
    endfunction

    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
        
    endfunction

    initial begin

        for(integer test_cases=0; test_cases<1000; test_cases++) begin
                /* Seed Inputs */
                for(int i=0;i<N;i++) begin mux_input[i] = $urandom(); end
                
                /* Test 2-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 2; input_selector++) begin
                    mux_select_1bit = input_selector;
                    #100;
                    print_test_input("[2-1 MUX TEST]", mux_output[0], mux_select_1bit);
                    assert(mux_output[0] == mux_input[mux_select_1bit]) else $fatal;
                end
                print_break();

                /* Test 4-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 4; input_selector++) begin
                    mux_select_2bit = input_selector;
                    #100;
                    print_test_input("[4-1 MUX TEST]", mux_output[1], input_selector);
                    assert(mux_output[1] == mux_input[mux_select_2bit]) else $fatal;
                end
                print_break();

                /* Test 8-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 8; input_selector++) begin
                    mux_select_3bit = input_selector;
                    #100;
                    print_test_input("[8-1 MUX TEST]", mux_output[2], input_selector);
                    assert(mux_output[2] == mux_input[mux_select_3bit]) else $fatal;
                end
                print_break();


    
              
                $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        
 
        $finish;
    end
endmodule