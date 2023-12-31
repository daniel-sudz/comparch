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


    function void print_state();
        $display("|---------------------------------------|");
        $display("| Register File State                   |");
        $display("|---------------------------------------|");
        $display("| %12s = 0x%8h (%10d)|", "x00, zero", xn[0], xn[0]);
        $display("| %12s = 0x%8h (%10d)|", "x01, ra", xn[1], xn[1]);
        $display("| %12s = 0x%8h (%10d)|", "x02, sp", xn[2], xn[2]);
        $display("| %12s = 0x%8h (%10d)|", "x03, gp", xn[3], xn[3]);
        $display("| %12s = 0x%8h (%10d)|", "x04, tp", xn[4], xn[4]);
        $display("| %12s = 0x%8h (%10d)|", "x05, t0", xn[5], xn[5]);
        $display("| %12s = 0x%8h (%10d)|", "x06, t1", xn[6], xn[6]);
        $display("| %12s = 0x%8h (%10d)|", "x07, t2", xn[7], xn[7]);
        $display("| %12s = 0x%8h (%10d)|", "x08, s0", xn[8], xn[8]);
        $display("| %12s = 0x%8h (%10d)|", "x09, s1", xn[9], xn[9]);
        $display("| %12s = 0x%8h (%10d)|", "x10, a0", xn[10], xn[10]);
        $display("| %12s = 0x%8h (%10d)|", "x11, a1", xn[11], xn[11]);
        $display("| %12s = 0x%8h (%10d)|", "x12, a2", xn[12], xn[12]);
        $display("| %12s = 0x%8h (%10d)|", "x13, a3", xn[13], xn[13]);
        $display("| %12s = 0x%8h (%10d)|", "x14, a4", xn[14], xn[14]);
        $display("| %12s = 0x%8h (%10d)|", "x15, a5", xn[15], xn[15]);
        $display("| %12s = 0x%8h (%10d)|", "x16, a6", xn[16], xn[16]);
        $display("| %12s = 0x%8h (%10d)|", "x17, a7", xn[17], xn[17]);
        $display("| %12s = 0x%8h (%10d)|", "x18, s2", xn[18], xn[18]); 
        $display("| %12s = 0x%8h (%10d)|", "x19, s3", xn[19], xn[19]); 
        $display("| %12s = 0x%8h (%10d)|", "x20, s4", xn[20], xn[20]); 
        $display("| %12s = 0x%8h (%10d)|", "x21, s5", xn[21], xn[21]); 
        $display("| %12s = 0x%8h (%10d)|", "x22, s6", xn[22], xn[22]); 
        $display("| %12s = 0x%8h (%10d)|", "x23, s7", xn[23], xn[23]); 
        $display("| %12s = 0x%8h (%10d)|", "x24, s8", xn[24], xn[24]); 
        $display("| %12s = 0x%8h (%10d)|", "x25, s9", xn[25], xn[25]); 
        $display("| %12s = 0x%8h (%10d)|", "x26, s10", xn[26], xn[26]); 
        $display("| %12s = 0x%8h (%10d)|", "x27, s11", xn[27], xn[27]); 
        $display("| %12s = 0x%8h (%10d)|", "x28, t3", xn[28], xn[28]); 
        $display("| %12s = 0x%8h (%10d)|", "x29, t4", xn[29], xn[29]); 
        $display("| %12s = 0x%8h (%10d)|", "x30, t5", xn[30], xn[30]); 
        $display("| %12s = 0x%8h (%10d)|", "x31, t6", xn[31], xn[31]); 
        $display("|---------------------------------------|");
    endfunction // print_state

endmodule