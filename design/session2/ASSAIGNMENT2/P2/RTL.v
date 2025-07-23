module P2_RTL (D,S1,S0,Y3,Y2,Y1,Y0);
input D,S1,S0 ;
output reg Y3,Y2,Y1,Y0;
always @(*) begin
    case ({S1,S0,D})
    3'b000 : {Y3,Y2,Y1,Y0} = 4'b0000 ;
    3'b010 : {Y3,Y2,Y1,Y0} = 4'b0000 ;
    3'b100 : {Y3,Y2,Y1,Y0} = 4'b0000 ;
    3'b110 : {Y3,Y2,Y1,Y0} = 4'b0000 ;
    3'b001 : {Y3,Y2,Y1,Y0} = 4'b0001 ;
    3'b011 : {Y3,Y2,Y1,Y0} = 4'b0010 ;
    3'b101 : {Y3,Y2,Y1,Y0} = 4'b0100 ;
    3'b111 : {Y3,Y2,Y1,Y0} = 4'b1000 ;
endcase
end
endmodule