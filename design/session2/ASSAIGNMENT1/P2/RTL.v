module p2_RTL (opcode,in0,in1,out,clk,rst);
parameter N =4;
input [N-1:0] in0 , in1 ;
input clk , rst;
input [1:0] opcode;
output reg [N-1:0] out ;

always @(posedge clk or posedge rst) begin
    if (rst) 
    out = 4'b0000;
    else begin
    case (opcode)
        2'b00 : out = in0+in1;
        2'b01 : out = in0|in1;
        2'b10 : out = in0-in1;
        2'b11 : out = in0^in1;
    endcase
    end
end
endmodule