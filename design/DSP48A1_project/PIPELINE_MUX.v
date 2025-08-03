module pipeline_mux(D,clk,Q,rst,CE);
    parameter WIDTH = 18 ; 
    parameter ENABLE = 1 ; // default 
    parameter RST_MODE = "SYNC" ;  // default 
    input [WIDTH-1:0] D;
    input clk ;
    input rst ;
    input CE ;
    output reg [WIDTH-1:0] Q ;
    generate
        if (ENABLE) begin
            if (RST_MODE == "SYNC") begin
            always @(posedge clk) begin
                if (rst)
                Q <= 0;
                else if (CE)
                Q <= D;
                end
            end
            else begin
            always @(posedge clk or posedge rst) begin
                if (rst)
                Q <= 0;
                else if (CE)
                Q <= D;
                end
            end
        end
        else begin
            always @(*) begin
                Q = D;
            end
        end
    endgenerate
endmodule