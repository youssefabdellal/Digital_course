module p6 (in0, in1 , opcode , out , enable , a,b,c,d,e,f,g);
parameter width = 4 ;
input [width-1:0] in0,in1 , enable;
input [1:0] opcode;
output reg [width-1:0] out;
output reg a,b,c,d,e,f,g;

always @ (in0, in1 , opcode ) begin
case (opcode) 
2'b00: out=in0+in1;
2'b01: out=in0|in1;
2'b10: out=in0-in1;
2'b11: out=in0^in1;
endcase 

if (enable==1) begin
    case (out)
        4'h0: {a,b,c,d,e,f,g} = 7'b1111110;
        4'h1: {a,b,c,d,e,f,g} = 7'b0110000;
        4'h2: {a,b,c,d,e,f,g} = 7'b1101101;
        4'h3: {a,b,c,d,e,f,g} = 7'b1111001;
        4'h4: {a,b,c,d,e,f,g} = 7'b0110011;
        4'h5: {a,b,c,d,e,f,g} = 7'b1011011;
        4'h6: {a,b,c,d,e,f,g} = 7'b1011111;
        4'h7: {a,b,c,d,e,f,g} = 7'b1110000;
        4'h8: {a,b,c,d,e,f,g} = 7'b1111111;
        4'h9: {a,b,c,d,e,f,g} = 7'b1111011;
        4'hA: {a,b,c,d,e,f,g} = 7'b1110111;
        4'hB: {a,b,c,d,e,f,g} = 7'b0011111;
        4'hC: {a,b,c,d,e,f,g} = 7'b1001110;
        4'hD: {a,b,c,d,e,f,g} = 7'b0111101;
        4'hE: {a,b,c,d,e,f,g} = 7'b1001111;
        4'hF: {a,b,c,d,e,f,g} = 7'b1000111;
        default : {a,b,c,d,e,f,g} = 7'b0000000;
    endcase
  end 
else  {a,b,c,d,e,f,g} = 7'b0000000;
end 
    endmodule

        