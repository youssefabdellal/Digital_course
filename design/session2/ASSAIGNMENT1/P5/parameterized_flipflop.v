module parameterized_FF (d , rstn , clk , Q, Qbar);
parameter string FF_type = "DFF" ;
input d , rstn , clk ;
output reg Q , Qbar ;
generate
    if (FF_type == "DFF") begin
        D_flipflop D1 (d , rstn , clk , Q, Qbar);
    end
    else if (FF_type == "TFF") begin
        T_flipflop T1 (d , rstn , clk , Q, Qbar)
    end
endgenerate
endmodule 


