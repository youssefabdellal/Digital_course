module p1_RTL (in0,in1,out);
parameter N =4;
parameter opcode = 0 ; 
input [N-1:0] in0 , in1  ;
output reg [N-1:0] out ;

always @(*) begin
    case (opcode)
        0 : out = in0+in1;
        1 : out = in0|in1;
        2 : out = in0-in1;
        3 : out = in0^in1;
    endcase
end
endmodule 