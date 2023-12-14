/*
 * d_flop_with_reset example
 *      a d-flop passes through in_1 on a pos-edge of the clock
 *      when pos-edge of reset is triggered, the output resets to low regardless of previous input
 */

module d_flop_with_reset (clk,
                          reset,
                          in_1,
                          out_1);
		
		/* ----------- Port definition ----------- */
		input clk;
		input reset;
		input in_1;
		
		output out_1;
		reg  out_1;
		
		/* ----------- Wires ----------- */
		
		
		/* ----------- Design Implementation  ----------- */
		always @(posedge clk or posedge reset)
		begin
				if (reset)
				// static constant notation
						out_1 <= 1'b0;
				else
				// pass-through input
						out_1 <= in_1;
		end
		
		
endmodule
