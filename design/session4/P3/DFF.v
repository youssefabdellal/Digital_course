module DFF (D,CLK,Q);
input D;
input CLK;
output reg Q;

always @ (posedge CLK)
Q <= D;
endmodule 