module p4 (a , b );
parameter n = 2;
input [n-1:0] a;
output [2^n-1:0] b;

assign b = (a == 2'b00) ? 4'b0001 :
           (a == 2'b01) ? 4'b0010 :
           (a == 2'b10) ? 4'b0100 :
                          4'b1000 ;

endmodule

