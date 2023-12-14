
/* Design of 4-1 mux using binary module pattern */
module mux_4_1(input_1, input_2, input_3, input_4, select, mux_output);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] input_1, input_2, input_3, input_4; 
    input wire [1:0] select;

    /* ----- Outputs  ----- */
    output logic [N-1:0] mux_output;

    /* -----  Submodules -----  */ 
    logic [N-1:0] block_1_out ;
    mux_2_1 block_1(.input_1(input_1), .input_2(input_3), .select(select[1]), .mux_output(block_1_out) );

    logic [N-1:0] block_2_out ;
    mux_2_1 block_2(.input_1(input_2), .input_2(input_4), .select(select[1]), .mux_output(block_2_out) );

    logic [N-1:0] block_3_out ;
    mux_2_1 block_3(.input_1(block_1_out), .input_2(block_2_out), .select(select[0]), .mux_output(mux_output) );

endmodule