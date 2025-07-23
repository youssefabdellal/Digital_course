module parameterized_FF (d , rstn , clk , Q, Qbar);
parameter FF_type = 0 ;
input d , rstn , clk ;
output Q , Qbar ;
localparam DFF = 0;
localparam TFF = 1;
generate
    if (FF_type == DFF) begin
        D_flipflop D1 (d , rstn , clk , Q);
    end
    else if (FF_type == TFF ) begin
        T_flipflop T1 (d , rstn , clk , Q);
    end
endgenerate
endmodule 