module wrapper (wrapper_if wrapperif);
  logic  [9:0]  rx_data;
  logic         rx_valid;
  logic         tx_valid;
  logic [7:0]   tx_data;

  RAM   RAM_instance (rx_data,wrapperif.clk,wrapperif.rst_n,rx_valid,
                      tx_data,tx_valid);

  SLAVE SLAVE_instance (wrapperif.MOSI,wrapperif.MISO,wrapperif.SS_n,wrapperif.clk,
                       wrapperif.rst_n,rx_data,rx_valid,tx_data,tx_valid);

  assign wrapperif.rx_data  = rx_data;
  assign wrapperif.rx_valid = rx_valid;
  assign wrapperif.tx_data  = tx_data;
  assign wrapperif.tx_valid = tx_valid;

// assertions section
// assertion 1 : An assertion ensures that whenever reset is asserted, the output (MISO) is inactive.
  property p_reset_outputs_inactive;
  @(posedge wrapperif.clk) !wrapperif.rst_n |=> (wrapperif.MISO == 0 &&
                                                wrapperif.rx_valid == 0 &&
                                                wrapperif.rx_data  == 0);
  endproperty

  assert property (p_reset_outputs_inactive);
  cover property (p_reset_outputs_inactive);
// assertion 2 : An assertion to make sure that the MISO remains with a stable value eventually as long
//               as it is not a read data operation
  property stable_miso;
    @(wrapperif.clk) disable iff (!wrapperif.rst_n) (wrapperif.rx_data[9:8] != 2'b11) |=> $stable(wrapperif.MISO);
  endproperty

  assert property (stable_miso);
  cover property (stable_miso);

endmodule