import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_test_pkg::*;

module top();
  bit clk ,reset ;

  initial begin
    forever 
      #1 clk =~clk ;
  end

  ALSU_if ALSU_inst_if (clk) ;
  shift_reg_if SHIFTER_inst_if () ;

  shift_reg SHIFTER_inst_DUT (SHIFTER_inst_if.serial_in, SHIFTER_inst_if.direction, 
                                SHIFTER_inst_if.mode, SHIFTER_inst_if.datain, SHIFTER_inst_if.dataout);

  ALSU ALSU_inst_DUT (ALSU_inst_if.A, ALSU_inst_if.B, ALSU_inst_if.cin, 
                        ALSU_inst_if.serial_in, ALSU_inst_if.red_op_A, 
                        ALSU_inst_if.red_op_B, ALSU_inst_if.opcode, 
                        ALSU_inst_if.bypass_A, ALSU_inst_if.bypass_B, 
                        ALSU_inst_if.clk, ALSU_inst_if.rst, ALSU_inst_if.direction,
                        ALSU_inst_if.leds, ALSU_inst_if.out);

  assign SHIFTER_inst_if.serial_in = ALSU_inst_DUT.serial_in;
  assign SHIFTER_inst_if.direction = ALSU_inst_DUT.direction;
  assign SHIFTER_inst_if.mode = ALSU_inst_DUT.opcode;
  assign SHIFTER_inst_if.datain = ALSU_inst_DUT.out;
  assign SHIFTER_inst_if.reset  = ALSU_inst_DUT.rst;


  bind ALSU_inst_DUT ALSU_assertions inst_assertion  (
    .clk(ALSU_inst_if.clk),
    .rst(ALSU_inst_if.rst),
    .out(ALSU_inst_if.out),
    .leds(ALSU_inst_if.leds),
    .opcode(ALSU_inst_if.opcode),
    .bypass_A(ALSU_inst_if.bypass_A),
    .bypass_B(ALSU_inst_if.bypass_B),
    .red_op_A(ALSU_inst_if.red_op_A),
    .red_op_B(ALSU_inst_if.red_op_B),
    .direction(ALSU_inst_if.direction),
    .A(ALSU_inst_if.A),
    .B(ALSU_inst_if.B),
    .cin(ALSU_inst_if.cin),
    .serial_in(ALSU_inst_if.serial_in)
  );

  initial begin
    uvm_config_db #(virtual ALSU_if)::set(null, "uvm_test_top" , "ALSU_if" ,ALSU_inst_if) ;
    uvm_config_db #(virtual shift_reg_if)::set(null, "uvm_test_top" , "SHIFTER_if" ,SHIFTER_inst_if) ;
    run_test("ALSU_test");
  end

endmodule 