module testbench1 ();
reg [2:0] A_tb1 ;
wire [6:0] B_tb1 ;

P1_RTL #(.USE_GRAY(1)) DUT (A_tb1 , B_tb1);

integer i;
initial begin
    for (i =0 ; i<8 ;i=i+1) begin
        A_tb1 = i ;
        #10;
    end
    $stop;
end
initial begin
    $monitor ("A = %b , B = %b" , A_tb1 , B_tb1);
end
endmodule