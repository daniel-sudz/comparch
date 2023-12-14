/* Test muxes */

module test_mux ();

    parameter N = 32;

    logic [N-1:0] mux_input_1;
    logic [N-1:0] mux_input_2;
    logic mux_select;

    wire [N-1:0] mux_output_1;

    mux_2_1 mux21_a(.input_1(mux_input_1), .input_2(mux_input_2), .select(mux_select), .mux_output(mux_output_1));

    


    initial begin
        
        for(integer i1=0; i1 < 31; i1++) begin
            for(integer i2 = 0; i2 < 31; i2++) begin
                /* Test Mux 2-to-1 */
                mux_input_1 = (1 << i1);
                mux_input_2 = (1 << i2);
                mux_select = 0;

                #100;
                $display("mux_input_1 %d mux_input_2 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_select, mux_output_1);
                assert(mux_output_1 == mux_input_2);


                mux_select = 1;
                #100;

                $display("mux_input_1 %d mux_input_2 %d mux_select %d mux_output_1 %d", mux_input_1, mux_input_2, mux_select, mux_output_1);
                assert(mux_output_1 == mux_input_1);

            end
        end


        $finish;
    end
endmodule