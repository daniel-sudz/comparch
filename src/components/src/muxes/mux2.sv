
module mux2(in_0, in_1, s, out);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in_0, in_1; 
    input wire s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* ----- Design  ----- */
    assign out = s ? in_1 : in_0;


endmodule