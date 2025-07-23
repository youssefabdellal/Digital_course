module P1_tb2 ();
parameter N_tb =4;
reg [N_tb-1:0] in0_tb , in1_tb ,out_expected ;
wire[N_tb-1:0] out_tb ;

p1_RTL #(.N(N_tb),.opcode(1)) DUT (in0_tb,in1_tb,out_tb);

initial begin
    repeat (100)begin
       in0_tb = $random;
       in1_tb = $random;
       out_expected = in0_tb | in1_tb;
       #10;
       if (out_tb == out_expected)
       $display ("sucsses");
       else 
       $display ("fail"); 
    end  
end

initial begin
    $monitor ("in0=%b,in1=%b,opcode=00,out=%b",in0_tb,in1_tb,out_expected);
end
endmodule