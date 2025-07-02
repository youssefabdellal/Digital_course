module problem1 (A,out);
input [3:0] A ;
output reg  out ;

always @ (*) begin
    if (A < 8 && A > 2) begin
        out = 1'b1;
    end
    else out = 1'b0;
end
endmodule 