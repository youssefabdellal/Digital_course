module problem3 (A,B,C,F);
input A,B,C;
output F;
wire XOR , XNOR ;

xor (XOR,A,B);
xnor (XNOR,B,C);
and (F,XOR,XNOR,C);

endmodule 