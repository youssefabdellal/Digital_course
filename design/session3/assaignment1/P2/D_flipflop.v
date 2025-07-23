module D_flipflop (d , rstn , clk , Q );
input d , rstn , clk ;
output reg Q ;
wire Qbar ;
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