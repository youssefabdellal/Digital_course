interface SLAVE_if (clk);
    input clk ;
    logic rst_n ;
    logic MOSI ;
    logic SS_n ;
    logic tx_valid;
    logic [7:0] tx_data;
    logic [9:0] rx_data;
    logic rx_valid ;
    bit MISO;
endinterface