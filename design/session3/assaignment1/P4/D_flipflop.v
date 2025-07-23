module D_flipflop (d , rstn , clk , Q , Qbar);
input d , rstn , clk ;
output reg Q ;
output Qbar ;
assign Qbar = ~ Q ;

always @ (posedge clk or negedge rstn) begin
    if (~rstn) begin
        Q <=0 ;
    end
    else begin
        Q <= d ;
    end
end
endmodule 