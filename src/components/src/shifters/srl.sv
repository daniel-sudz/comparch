`default_nettype none

module srl(in, shamt, out);

    parameter N=32;

    input wire [N-1:0] in;
    input wire [$clog2(N)-1:0] shamt;
    output wire [N-1:0] out;

endmodule