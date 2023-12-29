`default_nettype none
`timescale 1ns/1ps

module register_file(
    rst, clk,
    wr_ena, wr_addr, wr_data,
    rd_addr0, rd_data0,
    rd_addr1, rd_data1);

    input wire clk, rst;

    // Write channel:
    input wire wr_ena;
    input wire [4:0] wr_addr;
    input wire [31:0] wr_data;

    // Two read channels:
    input wire [4:0] rd_addr0, rd_addr1;
    output logic [31:0] rd_data0, rd_data1;

    logic [31:0] x00; 
    always_comb x00 = 32'd0; // ties x00 to ground

    // DON'T DO THIS:
    // logic [31:0] register_file_registers [31:0];
    // CAN'T: because that's a RAM. Works in simulation, not synthesis. Technically if you implement it as a distribute ram it sort of works out, but the following more structural representation captures how much hardware/area the register file really takes.

endmodule