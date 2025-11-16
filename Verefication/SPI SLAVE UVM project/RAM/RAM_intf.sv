interface RAM_intf (input logic clk);
  parameter MEM_DEPTH = 256;
  parameter ADDR_SIZE = 8;

  // Inputs
  logic rst_n;
  logic [9:0] din;
  logic rx_valid;

  // Outputs DUT
  logic tx_valid;
  logic [7:0] dout;

  // Outputs Golden Model
  logic tx_valid_ref;
  logic [7:0] dout_ref;

  // Modports
  modport SVA (
    input  clk, rst_n, din, rx_valid,
    input  dout, tx_valid
  );
endinterface : RAM_intf
