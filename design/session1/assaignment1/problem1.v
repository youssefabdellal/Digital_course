module p1 (a,b,c,d,e,f,sel,out,out_bar) ;
input a,b,c,d,e,f,sel;
output out , out_bar;

wire AND1 , XNOR1;

and (AND1,a,b,c);
xnor(XNOR1,d,e,f);
assign out = (sel==1)?XNOR1:AND1;
assign out_bar = ~out;
endmodule 