module DSP48A1_tb ();
parameter operation = 0 ;
reg [17:0] A;
reg [17:0] B;
reg [47:0] C;
reg [17:0] D;
reg clk ;
reg rst_n;
wire[47:0] P;
reg [47:0] out_expected;
// instation RTL design
DSP48A1 #(.operation(operation)) DUT (A,B,C,D,clk,rst_n,P);
// clock generation 
initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end
// testing block 
initial begin
    rst_n = 0 ;
    A=1;
    B=15;
    C=18;
    D=13;
    @(negedge clk) ;
    if (P == 0) 
    $display ("rst functionality correct");
    else
    $display ("rst functionality wrong"); 
    rst_n = 1 ;
    @(negedge clk) ;
    A=10;
    B=5;
    C=8;
    D=3;
    out_expected = (D+B)*A+C;
    repeat(7) @(negedge clk) ;
    if (P == out_expected)
    $display ("test passed");
    else
    $display ("test failed");
    A=14;
    B=50;
    C=12;
    D=32;
    out_expected = (D+B)*A+C;
    repeat(7) @(negedge clk) ; 
    if (P == out_expected)
    $display ("test passed");
    else
    $display ("test failed"); 
    $stop;
end
endmodule