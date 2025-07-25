module DSP48A1 (A,B,C,D,clk,rst_n,P);
// parameters
parameter operation = 0 ;   // ADD
// input ports
input [17:0] A;
input [17:0] B;
input [47:0] C;
input [17:0] D;
input clk ;
input rst_n;
// output port 
output reg [47:0] P;
// wire internal signal 
wire [17:0] A_reg1;
wire [17:0] A_reg2;
wire [17:0] B_reg;
wire [47:0] C_reg;
wire [17:0] D_reg;
wire [17:0] operation_out1_reg;
wire [47:0] multiplier_out_reg;
// reg internal signal 
reg [17:0] operation_out1;
reg [47:0] multiplier_out;
reg [47:0] operation_out2;
// instation blocks
DFF_18bits D_pp1 (D,clk,D_reg);
DFF_18bits B_pp1 (B,clk,B_reg);
DFF_18bits A_pp1 (A,clk,A_reg1);
DFF_48bits C_pp1 (C,clk,C_reg);
DFF_18bits A_pp2 (A_reg1,clk,A_reg2);
DFF_18bits operation_out1_pp2 (operation_out1,clk,operation_out1_reg);
DFF_48bits multiplier_out_pp3 (multiplier_out,clk,multiplier_out_reg);
// always block 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
    P <= 0 ;
    else begin
        P <= operation_out2;
        if (operation == 0) begin
            operation_out1 <= D_reg + B_reg ;
        end
        else begin
            operation_out1 <= D_reg - B_reg ;
        end
        multiplier_out <= A_reg2 * operation_out1_reg;
        if (operation == 0) begin
            operation_out2 <= multiplier_out_reg + C_reg ;
        end
        else begin
            operation_out2 <= multiplier_out_reg - C_reg ;
        end
    end
end
endmodule