/*
 * 2x4 multiplexer
 *
 */

module bus_signals (in_1,
                    in_2,
                    in_3,
                    out_1);
		
		/* ----------- Port definition ----------- */
		input [3:0] in_1;
		input [3:0] in_2;
		input in_3;
		
		output [3:0] out_1;
		
		
		/* ----------- Wires ----------- */
		wire [3:0] in_3_bus;
		
		
		/* ----------- Design Implementation  ----------- */
		assign in_3_bus = {4{in_3}};                              // scales in_3 out to a [3:0] with all values set to in_3
		assign out_1    = (~in_3_bus & in_1) | (in_3_bus & in_2); // select output based on multiplexer input
		
		
endmodule
