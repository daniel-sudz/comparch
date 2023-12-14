/*
 * Header Information
 *
 */

module simple_in_n_out (in_1,
                        in_2,
                        in_3,
                        out_1,
                        out_2,
                        out_3);
		
		/* ----------- Port definition ----------- */
		input in_1;
		input in_2;
		input in_3;
		
		output out_1;
		output out_2;
		output out_3;
		
		/* ----------- Design Implementation  ----------- */
		assign out_1 = in_1 & in_2 & in_3;
		assign out_2 = in_1 | in_2 | in_3;
		
		
endmodule
