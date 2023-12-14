/*
 * srflop_n_counter example
 *
 */

module srflop_n_counter (clk,
                         reset,
                         start,
                         stop,
                         count);
		
		/* ----------- Port definition ----------- */
		input clk;
		input reset;
		input start;
		input stop;
		output [3:0] count;
		
		reg cnt_enabled;
		reg [3:0] count;
		reg stop_d1;
		reg stop_d2;
		
		/* ----------- Wires ----------- */
		
		
		/* ----------- Design Implementation  ----------- */
		
		// SR flop
		always @(posedge clk or posedge reset)
		begin
				if (reset)
				// disable counting on reset
						cnt_enabled <= 1'b0;
				else if (start)
				// enable counting on start
						cnt_enabled <= 1'b1;
				else if (stop)
				// disable counting on stop
						cnt_enabled <= 1'b0;
				else
				// latch
						;
		end
		
		// counter
		always @(posedge clk or posedge reset)
		begin
				if (reset)
				// reset if reset is triggered
						count <= 4'h0;
				else if (cnt_enabled && count == 4'd13)
				// count using mod 14
						count <= 4'h0;
				else if (cnt_enabled)
				// increment count if count is enabled
						count <= count + 1;
				else
				// latch
						;
		end
		
		
endmodule
