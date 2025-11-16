interface wrapper_if(clk);
  input logic clk;
  logic MOSI,MISO_ref,SS_n,rst_n;
  bit MISO;
  logic tx_valid;
  logic [7:0] tx_data;
  logic [9:0] rx_data;
  logic rx_valid;
  modport wrp_sva (input  rx_data, rx_valid, clk, MOSI, MISO, SS_n, rst_n, tx_data, tx_valid);
endinterface