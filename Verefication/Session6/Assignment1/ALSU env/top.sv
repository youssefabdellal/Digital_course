import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_test_pkg::*;

module ALSU_top();
  bit clk ,reset ;
  initial begin
    forever 
      #1 clk =~clk ;
  end
  ALSU_if inst_if (clk) ;
  ALSU inst_DUT (inst_if.A, inst_if.B, inst_if.cin, inst_if.serial_in, 
                  inst_if.red_op_A, inst_if.red_op_B, inst_if.opcode, 
                    inst_if.bypass_A, inst_if.bypass_B, inst_if.clk, 
                    inst_if.rst, inst_if.direction, inst_if.leds, inst_if.out);
  bind inst_DUT ALSU_assertions inst_assertion  (
    .clk(inst_if.clk),
    .rst(inst_if.rst),
    .out(inst_if.out),
    .leds(inst_if.leds),
    .opcode(inst_if.opcode),
    .bypass_A(inst_if.bypass_A),
    .bypass_B(inst_if.bypass_B),
    .red_op_A(inst_if.red_op_A),
    .red_op_B(inst_if.red_op_B),
    .direction(inst_if.direction),
    .A(inst_if.A),
    .B(inst_if.B),
    .cin(inst_if.cin),
    .serial_in(inst_if.serial_in)
  );
  initial begin
    uvm_config_db #(virtual ALSU_if)::set(null, "uvm_test_top" , "ALSU_if" ,inst_if) ;
    run_test("ALSU_test");
  end
endmodule 