module ALU_4_bit (ALU_if.DUT ALU_DUT);

   reg signed [4:0] 	    Alu_out; // ALU output in 2's complement

   // Do the operation
   always @* begin
      case (ALU_DUT.opcode)
      	0:            Alu_out = ALU_DUT.A + ALU_DUT.B;
      	1:            Alu_out = ALU_DUT.A - ALU_DUT.B;
      	2:          Alu_out = ~ALU_DUT.A;
         3:  Alu_out = |ALU_DUT.B;
         default:  Alu_out = 5'b0;
      endcase
   end // always @ *

   // Register output C
   always @(posedge ALU_DUT.clk or posedge ALU_DUT.reset) begin
      if (ALU_DUT.reset)
	     ALU_DUT.C <= 5'b0;
      else
	     ALU_DUT.C<= Alu_out;
   end
endmodule