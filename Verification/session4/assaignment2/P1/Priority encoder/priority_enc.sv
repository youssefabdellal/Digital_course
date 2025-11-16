module priority_enc (priority_enc_if.DUT enc_DUT);

always @(posedge enc_DUT.clk) begin
  if (enc_DUT.rst) begin
	enc_DUT.Y <= 2'b0;
	enc_DUT.valid <= 0 ;
  end
  else begin
	casex (enc_DUT.D)
  		4'b1000: enc_DUT.Y <= 0;
  		4'bX100: enc_DUT.Y <= 1;
  		4'bXX10: enc_DUT.Y <= 2;
  		4'bXXX1: enc_DUT.Y <= 3;
  	endcase
  	enc_DUT.valid <= (~|enc_DUT.D)? 1'b0: 1'b1;
  end
end
endmodule