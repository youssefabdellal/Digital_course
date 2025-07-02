module problem5 (A,B,Ainvert,Binvert,CarryIn,operation,carryout,result);
input A,B,Ainvert,Binvert, CarryIn ;
input [1:0] operation ;
output carryout ;
output reg result ;
wire muxA , muxB , AND , OR ;
wire [1:0] sum;
assign muxA = (Ainvert == 0) ? A: ~A ;
assign muxB = (Binvert == 0) ? B: ~B ;
and (AND,muxA,muxB);
or (OR,muxA,muxB);
assign sum = muxA + muxB +CarryIn ;
assign carryout = sum[1];

always @(*) begin
    case (operation) 
        2'b00 : result = AND;
        2'b01 : result = OR;
        2'b10 : result = sum[0];
        2'b11 : result = 0;
    endcase
end
endmodule