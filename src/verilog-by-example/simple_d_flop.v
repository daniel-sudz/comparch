/*
 * simple_d_flop example
 * a d-flop passes through in_1 on a pos-edge of the clock
 *
 */

module simple_d_flop (clk,
                      in_1,
                      out_1);
		
		/* ----------- Port definition ----------- */
		input clk;
		input in_1;
		
		output out_1;
		reg  out_1;
		
		/* ----------- Wires ----------- */
		
		
		/* ----------- Design Implementation  ----------- */
		always @(posedge clk)
		begin
				out_1 <= in_1;
		end
		
		
endmodule
