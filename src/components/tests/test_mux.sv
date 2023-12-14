/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic [N-1:0] mux_input_1, mux_input_2, mux_input_3, mux_input_4;
    
    logic mux_select_1bit;
    logic [1:0] mux_select_2bit;

    wire [N-1:0] mux_output_1, mux_output_2;

    mux_2_1 mux21_a(.input_1(mux_input_1), .input_2(mux_input_2), .select(mux_select_1bit), .mux_output(mux_output_1));
    mux_4_1 mux41_a(.input_1(mux_input_1), .input_2(mux_input_2), .input_3(mux_input_3), .input_4(mux_input_4), .select(mux_select_2bit), .mux_output(mux_output_2));

    
    initial begin

        for(integer test_cases=0; test_cases<1000; test_cases++) begin
                /* Test Mux 2-to-1 */
                mux_input_1 = $urandom();
                mux_input_2 = $urandom();
                mux_input_3 = $urandom();
                mux_input_4 = $urandom();

                mux_select_1bit = 0;
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_select_1bit, mux_output_1);
                assert(mux_output_1 == mux_input_1);


                mux_select_1bit = 1;
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_select_1bit, mux_output_1);
                assert(mux_output_1 == mux_input_2);

                /* Test Mux 4-to-1 */
                mux_select_2bit = 0; 
                #100;


                $display("mux_input_1 %d mux_input_2 %d mux_input_3 %d mux_input_4 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_input_3, mux_input_4, mux_select_2bit, mux_output_2);
                assert(mux_input_1 == mux_output_2);

                mux_select_2bit = 1; 
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_input_3 %d mux_input_4 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_input_3, mux_input_4, mux_select_2bit, mux_output_2);
                assert(mux_input_2 == mux_output_2);

                mux_select_2bit = 2; 
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_input_3 %d mux_input_4 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_input_3, mux_input_4, mux_select_2bit, mux_output_2);
                assert(mux_input_3 == mux_output_2);


                mux_select_2bit = 3; 
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_input_3 %d mux_input_4 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_input_3, mux_input_4, mux_select_2bit, mux_output_2);
                assert(mux_input_4 == mux_output_2);





                $display("random test iteration %d", test_cases);
        end
        
 
        $finish;
    end
endmodule