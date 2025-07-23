module ripplecounter_RTL (clk , rstn , out);
input clk , rstn ;
output  [3:0] out ;
wire  q0 , q1 , q2 , q3 ;
wire  qn0 , qn1 , qn2 , qn3 ;
D_flipflop ff1 (~q0 ,  rstn , clk , q0 , qn0);
D_flipflop ff2 (~q1 ,  rstn , q0 , q1 , qn1);
D_flipflop ff3 (~q2 ,  rstn , q1 , q2 , qn2);
D_flipflop ff4 (~q3 ,  rstn , q2 , q3 , qn3);
assign out = {qn3 , qn2 , qn1 , qn0 };
endmodule