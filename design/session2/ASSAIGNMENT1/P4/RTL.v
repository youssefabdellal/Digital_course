module p4_RTL (aset , data , gate , aclr , Q);
parameter LAT_WIDTH = 4 ;
input aset  , gate , aclr ;
input [LAT_WIDTH-1 : 0] data;
output reg [LAT_WIDTH -1 : 0] Q ;

always @ (*) begin
    if (aset && aclr)
    Q <= 4'b0000 ;
    else if (aset)
    Q <= 4'b1111 ;
    else if (aclr)
    Q <= 4'b0000 ;
    else if (gate)
    Q <= data;
end

endmodule
