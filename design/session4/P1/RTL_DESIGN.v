module ALSU (A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,leds,out);
// parameters 
parameter INPUT_PRIORITY = 0 ;
parameter FULL_ADDER = 0 ;
// local parameters 
localparam A_priority = 0 ;
localparam B_priority = 1 ;
localparam FULL_ADDER_on = 0 ;
localparam FULL_ADDER_off = 1 ;
// input signals
input [2:0]A;
input [2:0]B;
input [2:0] opcode;
input cin ;
input serial_in ;
input red_op_A;
input red_op_B;
input bypass_A;
input bypass_B;
input direction;
input clk;
input rst;
//output signals 
output [5:0] out ;
output [15:0] leds;
//internal signals 
wire [2:0] A_reg;
wire [2:0] B_reg;
wire [2:0] opcode_reg;
wire cin_reg;
wire serial_in_reg;
wire red_op_A_reg;
wire red_op_B_reg;
wire bypass_A_reg;
wire bypass_B_reg;
wire direction_reg;
reg [5:0] out_reg;
reg [15:0] leds_reg;
// DFF for input A
DFF A2_DFF (A[2],clk,A_reg[2]);
DFF A1_DFF (A[1],clk,A_reg[1]);
DFF A0_DFF (A[0],clk,A_reg[0]);
// DFF for input B
DFF B2_DFF (B[2],clk,B_reg[2]);
DFF B1_DFF (B[1],clk,B_reg[1]);
DFF B0_DFF (B[0],clk,B_reg[0]);
// DFF for input opcode
DFF opcode2_DFF (opcode[2],clk,opcode_reg[2]);
DFF opcode1_DFF (opcode[1],clk,opcode_reg[1]);
DFF opcode0_DFF (opcode[0],clk,opcode_reg[0]);
// DFF for input cin
DFF cin_DFF (cin,clk,cin_reg);
// DFF for input serial_in
DFF serial_in_DFF (serial_in,clk,serial_in_reg);
// DFF for input red_op_A
DFF red_op_A_DFF (red_op_A,clk,red_op_A_reg);
// DFF for input red_op_B
DFF red_op_B_DFF (red_op_B,clk,red_op_B_reg);
// DFF for input bypass_A
DFF bypass_A_DFF (bypass_A,clk,bypass_A_reg);
// DFF for input bypass_B
DFF bypass_B_DFF (bypass_B,clk,bypass_B_reg);
// DFF for input direction
DFF direction_DFF (direction,clk,direction_reg);
always @ (posedge clk or posedge rst) begin
    // active high reset 
    if (rst) begin
        out_reg <= 6'b000000;
        leds_reg <= 16'b0000000000000000;
    end
    else begin
        if ( (red_op_A_reg | red_op_B_reg) && !( (opcode == 3'b000) || (opcode == 3'b001) ) )  begin
        out_reg <= 6'b000000;
        leds_reg <= ~leds_reg;
        end
        // checking bypass signals
        else if (bypass_A_reg && bypass_B_reg) begin
        if (INPUT_PRIORITY == 0 ) 
        out_reg <= A_reg ;
        else 
        out_reg <= B_reg ;
        end
        else if (bypass_A_reg)
        out_reg <= A_reg ;
        else if (bypass_B_reg)
        out_reg <= B_reg ;
    // checkig opcode different cases  
        else begin
            case (opcode_reg)
                3'b000: begin   // AND
                    if (red_op_A_reg&&red_op_B_reg) begin
                        if (INPUT_PRIORITY == 0 )
                        out_reg <= &A_reg ;
                        else 
                        out_reg <= &B_reg ;
                        end
                    else if (red_op_A_reg)
                    out_reg <= &A_reg ;
                    else if (red_op_B_reg)
                    out_reg <= &B_reg ;
                    else 
                    out_reg <= A & B ;
                end
                3'b001: begin // XOR
                    if (red_op_A_reg && red_op_B_reg) begin
                        if (INPUT_PRIORITY == 0 )
                        out_reg <= ^A_reg ;
                        else 
                        out_reg <= ^B_reg ;
                    end
                    else if (red_op_A_reg)
                    out_reg <= ^A_reg ;
                    else if (red_op_B_reg)
                    out_reg <= ^B_reg ;
                    else 
                    out_reg <= A ^ B ;
                end
                3'b010: begin // ADDITION
                    if (FULL_ADDER == 0) 
                    out_reg <= A_reg + B_reg + cin_reg ; 
                    else 
                    out_reg <= A_reg + B_reg  ;
                end
                3'b011: begin // MULTIPLICATION
                    out_reg <= A_reg * B_reg ;
                end
                3'b100: begin // SHIFTING
                    if (direction_reg)
                    out_reg <= {serial_in_reg , out_reg[5:1]};
                    else
                    out_reg <= {out_reg[4:0] , serial_in_reg}; 
                end
                3'b101: begin // ROTATION
                    if (direction_reg)
                    out_reg <= {out_reg[4:0] , out_reg[5]};
                    else 
                    out_reg <= {out_reg[0] , out_reg[5:1]};
                end
                3'b110: begin // INVALID OPCODE 
                    out_reg <= 6'b000000;
                    leds_reg <= ~leds_reg;
                end
                3'b111: begin // INVALID OPCODE
                    out_reg <= 6'b000000;
                    leds_reg <= ~leds_reg;
                end
            endcase
            end
        end
end
assign out = out_reg;
assign leds = leds_reg;
endmodule               