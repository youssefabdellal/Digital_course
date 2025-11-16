////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter_d (counter_if.DUT c_DUT);
always @(posedge c_DUT.clk) begin
    if (!c_DUT.rst_n)
        c_DUT.count_out <= 0;
    else if (!c_DUT.load_n)
        c_DUT.count_out <= c_DUT.data_load;
    else if (c_DUT.ce)
        if (c_DUT.up_down)
            c_DUT.count_out <= c_DUT.count_out + 1;
        else 
            c_DUT.count_out <= c_DUT.count_out - 1;
end

assign c_DUT.max_count = (c_DUT.count_out == {c_DUT.WIDTH{1'b1}})? 1:0;
assign c_DUT.zero = (c_DUT.count_out == 0)? 1:0;

endmodule