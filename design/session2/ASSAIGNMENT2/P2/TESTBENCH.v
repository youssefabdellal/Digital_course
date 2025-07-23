module P2_TESTBENCH();
reg D_tb , S1_tb , S0_tb ;
wire Y3_tb , Y2_tb , Y1_tb , Y0_tb ;

P2_RTL DUT (D_tb , S1_tb , S0_tb , Y3_tb , Y2_tb , Y1_tb , Y0_tb);
integer i , j ;
initial begin
    D_tb = 1'b0 ;
    for ( i = 0 ; i < 2 ; i = i+1) begin
        S1_tb = i ;
        for (  j = 0 ; j < 2 ; j = j+1) begin
            S0_tb = j ;
            #10;
        end
    end
    D_tb = 1'b1 ;
    for ( i = 0 ; i < 2 ; i = i+1) begin
        S1_tb = i ;
        for ( j = 0 ; j < 2 ; j = j+1) begin
            S0_tb = j ;
            #10;
        end
    end
    $stop;
end

initial begin
    $monitor ("D = %b , S1 =%b , S0 =%b ,Y3=%b , Y2=%b , Y1 =%b, Y0=%b" ,D_tb , S1_tb , S0_tb ,Y3_tb , Y2_tb , Y1_tb , Y0_tb );
end
endmodule 