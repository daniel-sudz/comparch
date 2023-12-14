/* Sample file to test */

module test_sample ();

    logic in_1, out_1; 

    sample sample_obj (.a(in_1), .b(out_1));

    initial begin

        in_1 = 1;
        
        $display("in_1 %d, out_1 %d", in_1, out_1);
        assert(in_1 == out_1)


        $finish;
    end
endmodule