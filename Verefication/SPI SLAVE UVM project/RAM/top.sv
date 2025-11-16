import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;

module top();
  // Clock generation
  bit clk = 0;
  initial begin
    forever
      #1 clk =~clk ;
  end
  
  // Instantiate the interface and DUT
  RAM_intf RAM_if (clk);
  
  RAM DUT
  (
    .clk         (RAM_if.clk),
    .rst_n       (RAM_if.rst_n),
    .din         (RAM_if.din),
    .rx_valid    (RAM_if.rx_valid),
    .tx_valid    (RAM_if.tx_valid),
    .dout        (RAM_if.dout)
  );

  // Golden Model
  RAM_golden GOLDEN
  (
    .clk             (RAM_if.clk),
    .rst_n           (RAM_if.rst_n),
    .din             (RAM_if.din),
    .rx_valid        (RAM_if.rx_valid),
    .tx_valid_ref    (RAM_if.tx_valid_ref),
    .dout_ref        (RAM_if.dout_ref)
  );

  //Assertions
  bind RAM RAM_sva sva_inst (RAM_if.SVA);

  initial begin
    uvm_config_db# (virtual RAM_intf)::set(null,"","RAM_IF", RAM_if) ; 
    run_test ("RAM_test") ;
  end
endmodule
