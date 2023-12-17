/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic [N-1:0] mux_input [N-1:0];
    
    logic mux_select_1bit;
    logic [1:0] mux_select_2bit;
    logic [2:0] mux_select_3bit;
    logic [3:0] mux_select_4bit;
    logic [4:0] mux_select_5bit;


    wire [N-1:0] mux_output [4:0];

    mux2 mux21_a(
         mux_input[0],
         mux_input[1],
         mux_select_1bit,
         mux_output[0]);

    mux4 mux41_a(
         mux_input[0],
         mux_input[1],
         mux_input[2],
         mux_input[3],
         mux_select_2bit,
         mux_output[1]);

    mux8 mux81_a(
         mux_input[0],
         mux_input[1],
         mux_input[2],
         mux_input[3],
         mux_input[4],
         mux_input[5],
         mux_input[6],
         mux_input[7],
         mux_select_3bit,
         mux_output[2]);
    
    mux16 mux161_a(
        mux_input[0],
        mux_input[1],
        mux_input[2],
        mux_input[3],
        mux_input[4],
        mux_input[5],
        mux_input[6],
        mux_input[7],
        mux_input[8],
        mux_input[9],
        mux_input[10],
        mux_input[11],
        mux_input[12],
        mux_input[13],
        mux_input[14],
        mux_input[15],
        mux_select_4bit,
        mux_output[3]);
    
    mux32 mux321_a(
        mux_input[0],
        mux_input[1],
        mux_input[2],
        mux_input[3],
        mux_input[4],
        mux_input[5],
        mux_input[6],
        mux_input[7],
        mux_input[8],
        mux_input[9],
        mux_input[10],
        mux_input[11],
        mux_input[12],
        mux_input[13],
        mux_input[14],
        mux_input[15],
        mux_input[16],
        mux_input[17],
        mux_input[18],
        mux_input[19],
        mux_input[20],
        mux_input[21],
        mux_input[22],
        mux_input[23],
        mux_input[24],
        mux_input[25],
        mux_input[26],
        mux_input[27],
        mux_input[28],
        mux_input[29],
        mux_input[30],
        mux_input[31],
        mux_select_5bit,
        mux_output[4]);

    function void print_test_input(int unsigned mux_type, int unsigned display_out, int unsigned select_in);
        begin
            $write("[%0d-1 MUX TEST] mux input: [", mux_type);
            for(int i=0;i<mux_type;i++) begin
                $write("%0d,", mux_input[i]);
            end
            $display("], mux_select: [%0d], mux_output: [%0d]", select_in, display_out);
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
                    #10;
                    print_test_input(2, mux_output[0], mux_select_1bit);
                    assert(mux_output[0] == mux_input[mux_select_1bit]) else $fatal;
                end
                print_break();

                /* Test 4-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 4; input_selector++) begin
                    mux_select_2bit = input_selector;
                    #10;
                    print_test_input(4, mux_output[1], input_selector);
                    assert(mux_output[1] == mux_input[mux_select_2bit]) else $fatal;
                end
                print_break();

                /* Test 8-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 8; input_selector++) begin
                    mux_select_3bit = input_selector;
                    #10;
                    print_test_input(8, mux_output[2], input_selector);
                    assert(mux_output[2] == mux_input[mux_select_3bit]) else $fatal;
                end
                print_break();

                /* Test 16-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 16; input_selector++) begin
                    mux_select_4bit = input_selector;
                    #10;
                    print_test_input(16, mux_output[3], input_selector);
                    assert(mux_output[3] == mux_input[mux_select_4bit]) else $fatal;
                end
                print_break();


                /* Test 32-1 mux */
                print_break();
                for(int input_selector=0; input_selector < 32; input_selector++) begin
                    mux_select_5bit = input_selector;
                    #10;
                    print_test_input(32, mux_output[4], input_selector);
                    assert(mux_output[4] == mux_input[mux_select_5bit]) else $fatal;
                end
                print_break();

                $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        
 
        $finish;
    end
endmodule