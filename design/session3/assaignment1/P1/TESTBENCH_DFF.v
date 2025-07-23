module DFF_TB ();
reg D,E,PRE,clk ;
wire Q ;

DFF DUT (D,E,PRE,clk,Q);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end


initial begin
    PRE = 0 ; 
    @ (negedge clk);
    PRE = 1 ;
    repeat (15) begin
        D = $random ;
        E = $random ;
        @(negedge clk)
        if (E) begin
        if (Q == D)
        $display ("correct");
        else 
        $display ("wrong");
        end
        else 
        $display ("enable disabled");
    end
    $stop;
end
endmodule