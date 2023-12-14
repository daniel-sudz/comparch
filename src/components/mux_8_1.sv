
/* Design of 8-1 mux using binary module pattern */
module mux_8_1(input_1, input_2, input_3, input_4, input_5, input_6, input_7, input_8, select, mux_output);
   

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] input_1, input_2, input_3, input_4, input_5, input_6, input_7, input_8; 
    input wire [2:0] select;

    /* ----- Outputs  ----- */
    output logic [N-1:0] mux_output;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux_4_1 block_1(.input_1(input_1), .input_2(input_3), .input_3(input_5), .input_4(input_7), .select(select[2:1]), .mux_output(block_1_out) );

    logic [N-1:0] block_2_out ;
    mux_4_1 block_2(.input_1(input_2), .input_2(input_4), .input_3(input_6), .input_4(input_8), .select(select[2:1]), .mux_output(block_2_out) );

    mux_2_1 block_3(.input_1(block_1_out), .input_2(block_2_out), .select(select[0]), .mux_output(mux_output) );

endmodule