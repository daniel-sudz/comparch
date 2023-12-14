/*
 * d_flop_enable_and_clear example
 *      a d-flop passes through in_1 on a pos-edge of the clock
 *      when pos-edge of reset is triggered, the output resets to low regardless of previous input
 */

module d_flop_enable_and_clear (clk,
                                reset,
                                in_1,
                                enable,
                                clear,
                                out_1);
		
		/* ----------- Port definition ----------- */
		input clk;
		input reset;
		input in_1;
		input enable;
		input clear;
		
		output out_1;
		reg  out_1;
		
		/* ----------- Wires ----------- */
		
		
		/* ----------- Design Implementation  ----------- */
		always @(posedge clk or posedge reset)
		begin
				if (reset)
				// if reset is on pos_edge give low
						out_1 <= 1'b0;
				else if (clear == 1'b0)
				// if clear is high then give low
						out_1 <= 1'b0;
				else if (enable)
				// if enabled then pass-through input
						out_1 <= in_1;
				
				
		end
		
		
endmodule
