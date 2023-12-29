`timescale 1ns/1ps
`default_nettype none

/* Implements a synchronous register (batch of flip flops) with rst > ena.
 *      .clk -> input clock (1-bit)
 *      .ena -> synchronous enable (1-bit)
 *      .rst -> synchronous reset (1-bit)
 *      .q -> the state of the register (n-bit)
 *      .d -> value to write to register if enabled (n-bit)
 *      
 *      #N size of the flip flop
 *      #RESET_VALUE = 0 -> default value to use when rst is triggered (n-bit)
 */  
module register(clk, ena, rst, d, q);
    /* ----- Parameters  ----- */
    parameter N = 1;
    parameter RESET_VALUE = 0; // Value to reset to.

    /* ----- Inputs  ----- */
    input wire clk, ena, rst;
    input wire [N-1:0] d;

    /* ----- Outputs  ----- */
    output logic [N-1:0] q;

    /* ----- Design  ----- */
    always_ff @(posedge clk) begin
        if (rst) begin
            q <= RESET_VALUE;
        end
        else begin
            if (ena) begin
            q <= d;
            end
        end
    end

endmodule