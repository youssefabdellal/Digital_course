import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();
  shift_reg_if inst_if () ;
  shift_reg inst_DUT (inst_if.serial_in, inst_if.direction, inst_if.mode, inst_if.datain, inst_if.dataout);
  initial begin
    uvm_config_db #(virtual shift_reg_if)::set(null, "uvm_test_top" , "shift_reg_if" ,inst_if) ;
    run_test("shift_reg_test");
  end
endmodule 