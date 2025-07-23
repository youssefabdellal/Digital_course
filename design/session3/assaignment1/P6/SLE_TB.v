module SLE_tb ();
reg D,clk,EN,ALn,ADn,SLn,SD,LAT;
wire Q ;

sle_RTL DUT (D,clk,EN,ALn,ADn,SLn,SD,LAT,Q);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    ALn = 0 ;
    @ (negedge clk);
    ALn = 1 ;
    LAT = 0 ;
    repeat (15) begin
        D = $random ;
        EN = $random ;
        ADn = $random ;
        SLn = $random ;
        SD = $random ;
        @ (negedge clk);
        if (~EN) begin
        $display ("Enable signal is low");
        end
        else begin
            if (SLn) begin
            if (Q == D)
            $display ("correct");
            else 
            $display ("wrong");
            end 
            else begin
            if (Q == SD)
            $display ("correct");
            else 
            $display ("wrong");
            end   
    end
    LAT = 1 ;
    repeat (15) begin
        D = $random ;
        EN = $random ;
        ADn = $random ;
        SLn = $random ;
        SD = $random ;
        @ (negedge clk);
        if (~EN) begin
        $display ("Enable signal is low");
        end
        else begin
            if (SLn) begin
            if (Q == D)
            $display ("correct");
            else 
            $display ("wrong");
            end 
            else begin
            if (Q == SD)
            $display ("correct");
            else 
            $display ("wrong");
            end   
        end
    end
    $stop ;
end
end
endmodule
