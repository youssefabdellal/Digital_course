module DFF (D,E,PRE,CLK,Q);
input D,E,PRE,CLK;
output reg Q;

always @ (posedge CLK or negedge PRE)
if (!PRE) Q=1;
else if (E) Q=D;
endmodule 