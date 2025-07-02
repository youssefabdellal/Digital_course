module p5 (a , b);
input [7:0] a;
output[8:0] b;
wire  parity ;
assign parity = (a[0]^a[1]^a[2]^a[3]^a[4]^a[5]^a[6]^a[7]);

assign b = {a,parity};
endmodule 
