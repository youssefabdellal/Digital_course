module P3 ();
    enum logic [1:0] {IDLE , GEN_BLK_ADDR , WAITO} cs ;
    bit clk ;
    bit get_data;

    property cs_property;
        @(posedge clk) $onehot(cs) ;
    endproperty
    // here cs nust be GEN_BLK_ADDR just one clock after (cs == IDLE && get_data) and after 64 clock it must be WAITO
    property cs_IDLE;
        @(posedge clk) (cs == IDLE && get_data ) |=> (cs == GEN_BLK_ADDR) ##64 (cs == WAITO) ;
    endproperty
    //  here cs nust be GEN_BLK_ADDR just one clock after (cs == IDLE && get_data) and stay the same for 64 clock and after that must be WAITO
    property cs_IDLE2;
        @(posedge clk) (cs == IDLE && get_data) |=> (cs == GEN_BLK_ADDR[*64] ##1 (cs == WAITO));
    endproperty

endmodule