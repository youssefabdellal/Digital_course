module DFF_18bits (D,CLK,Q);
input [17:0]D;
input CLK;
output  reg [17:0] Q;

always @ (posedge CLK)
Q <= D;
endmodule 