module RAM_sva(RAM_intf.SVA intf);

    // 1) reset
    property p_reset;
        @(posedge intf.clk)
            (!intf.rst_n) |=> (intf.dout == 0 && intf.tx_valid == 0);
    endproperty
    a_reset: assert property (p_reset)
        else $error("Assertion 1 failed");
    c_reset: cover property (p_reset);

    // 2) tx_valid is low 
    property p_tx_low;
        @(posedge intf.clk) disable iff (!intf.rst_n)
        ( (!intf.din[9]) && (!intf.din[8]) && intf.rx_valid) |=> (intf.tx_valid == 0);
    endproperty
    a_tx_low: assert property (p_tx_low)
        else $error("Assertion 2 failed");
    c_tx_low: cover property (p_tx_low);

    // 3) tx_valid rises then falls
    property p_tx_high;
        @(posedge intf.clk) disable iff (!intf.rst_n)
            ((intf.din[8] && intf.din[9]) && intf.rx_valid) |=> (intf.tx_valid == 1) |=> $fell(intf.tx_valid)[->1] ;
    endproperty
    a_tx_high: assert property (p_tx_high) 
    else $error("Assertion 3 failed");
    c_tx_high: cover property (p_tx_high);
    
    // 4) write address => write data
    property p_write;
        @(posedge intf.clk) disable iff (!intf.rst_n)
            (intf.din[9:8] == 2'b00) |=>##[0:2] (intf.din[9:8] inside {2'b00,2'b01});
    endproperty
    a_write: assert property (p_write) else $error("Assertion write failed");
    c_write: cover property (p_write);

    // 5) read address => read data
    property p_read;
        @(posedge intf.clk) disable iff (!intf.rst_n)
            (intf.din[9:8] == 2'b10) |=>##[0:2] ( intf.din[9:8] inside {2'b10,2'b11});
    endproperty
    a_read: assert property (p_read) else $error("Assertion read failed ");
    c_read: cover property (p_read);

endmodule