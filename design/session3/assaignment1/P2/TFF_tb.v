module TFF_tb ();
`define TFF 1
reg d_tb , rstn_tb , clk ;
wire Q_tb1 , Qbar_tb1 ;
wire Q_tb2 , Qbar_tb2 ;

parameterized_FF #( .FF_type(`TFF)) DUT (d_tb , rstn_tb , clk, Q_tb1 , Qbar_tb1);
T_flipflop DUT_goldenmodel (d_tb , rstn_tb , clk, Q_tb2 , Qbar_tb2);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rstn_tb = 0 ;
    @ (negedge clk) ;
    rstn_tb = 1 ;
    repeat (10) begin
        d_tb = $random ;
        if (Q_tb1 == Q_tb2) 
        $display ("sucsses");
        else 
        $display ("fail");
        @ (negedge clk) ;
    end
    $stop ;
end
endmodule