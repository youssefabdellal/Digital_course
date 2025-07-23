module TDM (in0,in1,in2,in3,rst,clk,out);
// input ports 
input [1:0] in0 ;
input [1:0] in1 ;
input [1:0] in2 ;
input [1:0] in3 ;
input rst;
input clk;
// output ports 
output [1:0] out;
// internal signals
reg [1:0] counter_out;
// always block
always @(posedge clk or posedge rst) begin
    if (rst)begin
        counter_out <= 0;
    end
    else begin
        if (counter_out != 3)
        counter_out <= counter_out + 1 ;
        else 
        counter_out <= 0 ;
    end
end
assign out = (counter_out == 2'b00) ? in0 :
             (counter_out == 2'b01) ? in1 :
             (counter_out == 2'b10) ? in2 :
                                      in3;
endmodule