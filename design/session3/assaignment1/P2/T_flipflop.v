module T_flipflop (t , rstn , clk , Q ,Qbar);
input t , rstn , clk ;
output reg Q , Qbar ;

always @ (posedge clk or negedge rstn) begin
    if (~rstn) begin
        Q <= 1'b0 ;
        Qbar <= 1'b1;
    end
    else if (t) begin
        Q <= Qbar;
        Qbar <= Q;
    end
end
endmodule