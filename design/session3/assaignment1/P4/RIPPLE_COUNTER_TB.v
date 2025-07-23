module ripplecounter_TB ();
reg clk , rstn ;
wire [3:0] out ;

ripplecounter_RTL DUT (clk , rstn , out);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rstn = 0 ;
    @ (negedge clk)
    rstn = 1;
    repeat (16) @ (negedge clk);
    $stop ; 
end
endmodule
