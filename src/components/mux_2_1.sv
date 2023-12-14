
module mux_2_1(input_1, input_2, select, mux_output);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] input_1; 
    input wire [N-1:0] input_2; 

    input wire select;

    /* ----- Outputs  ----- */
    output logic [N-1:0] mux_output;

    /* ----- Design  ----- */
    assign mux_output = select ? input_1 : input_2;


endmodule