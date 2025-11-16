import uvm_pkg::*;
`include "uvm_macros.svh"
import SLAVE_test_pkg::*;

module SLAVE_top();
  bit clk ,reset ;
  initial begin
    forever 
      #1 clk =~clk ;
  end
  SLAVE_if inst_if (clk) ;
  SLAVE inst_DUT (inst_if.MOSI,inst_if.MISO,inst_if.SS_n,inst_if.clk,inst_if.rst_n,inst_if.rx_data,inst_if.rx_valid,inst_if.tx_data,inst_if.tx_valid);

  initial begin
    uvm_config_db #(virtual SLAVE_if)::set(null, "uvm_test_top" , "SLAVE_if" ,inst_if) ;
    run_test("SLAVE_test");
  end
endmodule 