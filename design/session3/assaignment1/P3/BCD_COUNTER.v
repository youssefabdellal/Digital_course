module BCD_counter (clk , rst , clk_div10_out);
input clk , rst ;
output reg clk_div10_out ;

reg [3:0]count ;

always @ (posedge clk or posedge rst ) begin
    if (rst) begin
        clk_div10_out <= 0;
        count <= 4'b0000;  
    end
    else begin
        if (count == 9) begin
            clk_div10_out <= ~clk_div10_out ;
            count <= 4'b0000;  
        end
        else 
        count <= count + 1 ;
    end
end
endmodule