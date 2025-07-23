module p3_RTL (clr , G ,D , Q);
input clr , D , G ;
output reg Q ;

always @(*) begin
    if (!clr)
    Q <= 1'b0;
    else if (G)
    Q <= D ;
end
endmodule

