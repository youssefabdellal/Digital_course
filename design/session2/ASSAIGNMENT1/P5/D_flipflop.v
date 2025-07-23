module D_flipflop (d , rstn , clk , Q , Qbar);
input d , rstn , clk ;
output reg Q , Qbar ;

always @ (posedge clk or negedge rstn) begin
    if (~rstn) begin
        Q <= 0 ;
        Qbar <= 1 ;
    end
    else begin
        Q <= d ;
        Qbar <= ~d ;
    end
end
endmodule 