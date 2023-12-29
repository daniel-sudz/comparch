`default_nettype none
`timescale 1ns/1ps

/* Implements a synchronous register file for RISC-V with rst > ena.
 *      .clk -> input clock (1-bit)
 *      .rst -> synchronous reset (1-bit)
 *      
 *      .wr_ena -> if writing is enabled (1-bit)
 *      .wr_addr -> which address to write to (5-bit)
 *      .wr_data -> data to write (32-bit)
 *
 *      .rd_addr0 -> first address to read from (5-bit)
 *      .rd_addr0 -> first address read result (32-bit)
 *
 *      .rd_addr1 -> second address to read from (5-bit)
 *      .rd_addr1 -> second address read result (32-bit)  
 */  
module register_file(rst, clk, wr_ena, wr_addr, wr_data, rd_addr0, rd_data0, rd_addr1, rd_data1);

    /* ------------------------- Input  ------------------------- */
    input wire clk;
    input wire rst;

    // Write channel:
    input wire wr_ena;
    input wire [4:0] wr_addr;
    input wire [31:0] wr_data;

    // Two read channels:
    input wire [4:0] rd_addr0, rd_addr1;

    /* ------------------------- Outputs  ------------------------- */

    // Read result
    output logic [31:0] rd_data0, rd_data1;

    /* ------------------------- Design  ------------------------- */

    // create a decoder for the wr_addr
    logic [31:0] write_addr_decoded;
    decoder_5_to_32 write_decoder(.ena(1'b1), .in(wr_addr), .out(write_addr_decoded));

    // intermediates for our registers
    logic [31:0] xn [31:0];         
    
    // x00 is always zero constant
    assign xn[0] = 32'd0;     

    // codegen corresponding registers modules for every register 
    generate
        genvar i;
        for(i=1;i<32;i++) begin
            register #(32) REG(
                .clk(clk), 
                .ena(write_addr_decoded[i]), 
                .rst(rst), 
                .d(wr_data),
                .q(xn[i]));
        end
    endgenerate

    // mux out the read addresses
    always_comb rd_data0 = xn[rd_addr0];
    always_comb rd_data1 = xn[rd_addr1];

endmodule