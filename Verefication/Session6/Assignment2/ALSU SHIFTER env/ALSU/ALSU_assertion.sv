import uvm_pkg::*;  
`include "uvm_macros.svh"

module ALSU_assertions #(
    parameter INPUT_PRIORITY = "A"
) (
    input logic clk,
    input logic rst,
    input logic signed [5:0] out,
    input logic [15:0] leds,
    input logic [2:0] opcode,
    input logic bypass_A,
    input logic bypass_B,
    input logic red_op_A,
    input logic red_op_B,
    input logic direction,
    input logic signed [2:0] A,
    input logic signed [2:0] B, 
    input logic [1:0] cin,       
    input logic serial_in
);
    // logic signed [5:0] out ;
    // assign out = (opcode inside {3'b100, 3'b101}) ? out_shift_reg : out_ALSU;

    // 1. After reset, outputs must be zero (with proper timing)
    property reset_clears_outputs;
        @(posedge clk) rst |=> (out == 0) and (leds == 0);
    endproperty
    assert property(reset_clears_outputs)
        else `uvm_error("ASSERT", "Outputs not cleared after reset");

    // 2. Invalid opcode (110=6, 111=7) -> out must be 0 after 2 cycles
    property invalid_opcode_out_zero;
        @(posedge clk) disable iff (rst)
            (opcode inside {3'b110, 3'b111} && !bypass_A && !bypass_B) |=> ##1  (out == 0);
    endproperty
    assert property(invalid_opcode_out_zero)
        else `uvm_error("ASSERT", "Invalid opcode did not force out=0");

    // 3. Invalid opcode causes LEDs to toggle
    property invalid_opcode_leds_toggle;
        @(posedge clk) disable iff (rst)
            (opcode inside {3'b110, 3'b111}) |=> ##1 (leds == ~$past(leds));
    endproperty
    assert property(invalid_opcode_leds_toggle)
        else `uvm_error("ASSERT", "LEDs did not toggle on invalid opcode");

    // 4. Valid opcode -> LEDs must be 0
    property valid_opcode_leds_zero;
        @(posedge clk) disable iff (rst)
            !(opcode inside {3'b110, 3'b111}) && 
            !((red_op_A | red_op_B) && (opcode[1] | opcode[2])) 
            |=> ##1 (leds == 0);
    endproperty
    assert property(valid_opcode_leds_zero)
        else `uvm_error("ASSERT", "LEDs not zero for valid operation");

    // 5. Bypass_A active (and bypass_B not active) -> out = A after 2 cycles
    property bypass_A_correct;
        @(posedge clk) disable iff (rst)
            (bypass_A && !bypass_B) |-> ##2 (out == $past(A, 2));
    endproperty
    assert property(bypass_A_correct)
        else `uvm_error("ASSERT", "Bypass A mismatch");

    // 6. Bypass_B active (and bypass_A not active) -> out = B after 2 cycles
    property bypass_B_correct;
        @(posedge clk) disable iff (rst)
            (bypass_B && !bypass_A) |-> ##2 (out == $past(B, 2));
    endproperty
    assert property(bypass_B_correct)
        else `uvm_error("ASSERT", "Bypass B mismatch");

    // 7. Both bypass_A and bypass_B active -> priority based on parameter
    property both_bypass_priority_A;
        @(posedge clk) disable iff (rst)
            (bypass_A && bypass_B) |-> ##2 (out == $past(A, 2));
    endproperty
    assert property(both_bypass_priority_A)
        else `uvm_error("ASSERT", "Both bypass active - priority A failed");

    // 8. OR operation (opcode=000) without reduction
    property or_operation;
        @(posedge clk) disable iff (rst)
            (opcode == 3'b000 && !red_op_A && !red_op_B && !bypass_A && !bypass_B) 
            |-> ##2 (out == ($past(A, 2) | $past(B, 2)));
    endproperty
    assert property(or_operation)
        else `uvm_error("ASSERT", "OR operation failed");

    // 9. XOR operation (opcode=001) without reduction
    property xor_operation;
        @(posedge clk) disable iff (rst)
            (opcode == 3'b001 && !red_op_A && !red_op_B && !bypass_A && !bypass_B) 
            |-> ##2 (out == ($past(A, 2) ^ $past(B, 2)));
    endproperty
    assert property(xor_operation)
        else `uvm_error("ASSERT", "XOR operation failed");

    // 10. Reduction OR on A (opcode=000, red_op_A=1, red_op_B=0)
    property reduction_or_A;
        @(posedge clk) disable iff (rst)
            (opcode == 3'b000 && red_op_A && !red_op_B && !bypass_A && !bypass_B) 
            |-> ##2 (out == |$past(A, 2));
    endproperty
    assert property(reduction_or_A)
        else `uvm_error("ASSERT", "Reduction OR A failed");

    // 11. Invalid red_op with non-bitwise opcode -> out = 0
    property invalid_red_op;
        @(posedge clk) disable iff (rst)
            ((red_op_A | red_op_B) && (opcode[1] | opcode[2]) && !bypass_A && !bypass_B)
            |-> ##2 (out == 0);
    endproperty
    assert property(invalid_red_op)
        else `uvm_error("ASSERT", "Invalid red_op did not force out=0");


endmodule