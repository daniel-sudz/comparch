
module mux2(in0, in1, s, out);

    parameter  N = 32;
    
    /* ----- Inputs  ----- */
    input wire [N-1:0] in0, in1; 
    input wire s;

    /* ----- Outputs  ----- */
    output logic [N-1:0] out;

    /* ----- Design  ----- */
    assign out = s ? in1 : in0;


endmodule