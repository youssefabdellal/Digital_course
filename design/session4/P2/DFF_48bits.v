module DFF_48bits (D,CLK,Q);
input [47:0]D;
input CLK;
output reg [47:0] Q;

always @ (posedge CLK)
Q <= D;
endmodule 