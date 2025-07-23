module counter_tb ();
reg clk , rst  ;
wire clk_div10_out ;

BCD_counter DUT (clk , rst , clk_div10_out);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rst = 1 ;
    @ ( posedge clk)
    rst = 0 ;
    repeat (100) @ (posedge clk) ;
    $stop;
end

initial begin
    $monitor("Time = %0t | clk = %b  | clk_div10_out = %b", $time, clk , clk_div10_out);
end
endmodule