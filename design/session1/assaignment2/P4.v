module problem4 (in,s);
input [2:0] in;
output s;

assign s = ~|in ;
endmodule 