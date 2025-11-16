module priority_enc_sva(priority_enc_if.DUT enc_sva);
    property rst_on;
        @(posedge enc_sva.clk) (enc_sva.rst) |=> (enc_sva.valid == 0 && enc_sva.Y == 0) ;
    endproperty

    property rst_off_bit0;
        @(posedge enc_sva.clk) (!enc_sva.rst && enc_sva.D[0]) |=> (enc_sva.Y == 3&& enc_sva.valid == 1) ;
    endproperty

    property rst_off_bit1;
        @(posedge enc_sva.clk) (!enc_sva.rst && !enc_sva.D[0] && enc_sva.D[1] ) |=> (enc_sva.Y == 2&& enc_sva.valid == 1) ;
    endproperty

    property rst_off_bit2;
        @(posedge enc_sva.clk) (!enc_sva.rst && !enc_sva.D[0] && !enc_sva.D[1] && enc_sva.D[2]) |=> (enc_sva.Y == 1&& enc_sva.valid == 1) ;
    endproperty

    property rst_off_bit3;
        @(posedge enc_sva.clk) (!enc_sva.rst && !enc_sva.D[0] && !enc_sva.D[1] && !enc_sva.D[2] && enc_sva.D[3] ) |=> (enc_sva.Y == 0 && enc_sva.valid == 1) ;
    endproperty

    property rst_off_zero;
        @(posedge enc_sva.clk) (!enc_sva.rst && enc_sva.D == 0 ) |=> (enc_sva.valid == 0) ;
    endproperty

    assert property (rst_on) ;
    assert property (rst_off_bit0) ;
    assert property (rst_off_bit1) ;
    assert property (rst_off_bit2) ;
    assert property (rst_off_bit3) ;
    assert property (rst_off_zero) ;

    cover property (rst_on) ;
    cover property (rst_off_bit0) ;
    cover property (rst_off_bit1) ;
    cover property (rst_off_bit2) ;
    cover property (rst_off_bit3) ;
    cover property (rst_off_zero) ;

endmodule