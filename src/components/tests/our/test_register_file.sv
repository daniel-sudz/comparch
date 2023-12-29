`timescale 1ns/1ps
`default_nettype none

/* Test register file */
module test_register_file;

    parameter N = 32;

    logic rst; 
    logic clk; 
    logic wr_ena; 


    logic [4:0] wr_addr;
    logic [31:0] wr_data;

    logic[4:0] rd_addr0, rd_addr1;
    logic[31:0] rd_data0, rd_data1;

    register_file RFILE(.clk(clk), .rst(rst), .wr_ena(wr_ena), .wr_addr(wr_addr), .wr_data(wr_data), .rd_addr0(rd_addr0), .rd_data0(rd_data0), .rd_addr1(rd_addr1), .rd_data1(rd_data1));

    function void print_break;
        begin
            $display("--------------------------------------------------------------------");
        end
    endfunction

    // set the clock to pulse
    always #5 clk = ~clk; 

    initial begin
        // initialize the clock
        clk = 0;

        $dumpfile("test-register-file-ours.fst");
        $dumpvars(0, test_register_file);
        
        for(integer test_cases=0; test_cases<1000; test_cases++) begin
            for(integer i=1;i<32;i++) begin
                // write out to register
                @(negedge clk);
                wr_ena = 1;
                wr_addr = i;
                wr_data = $random();
                #5; 
                @(posedge clk);

                wr_ena = 0;
                rd_addr0 = i;
                rd_addr1 = i;
                #5;

                // check value of register
                $display("[register_file]: [rd_addr0: %0d], [rd_data0: %0d], [rd_addr1: %0d], [rd_data1: %0d], [exp_rd_data0: %0d]", rd_addr0, rd_data1, rd_addr1, rd_data1, wr_data);
                assert(wr_data == rd_data0) else $fatal;
                assert(wr_data == rd_data1) else $fatal;
                
            end
            $display("[PASS RANDOM TEST] iteration #%d", test_cases);
        end
        $finish;
    end
endmodule