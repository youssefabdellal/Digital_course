module priority_enc_tb(priority_enc_if.TEST enc_TEST);
    integer D_count ;

    initial begin
        enc_TEST.rst = 1 ;
        @(negedge enc_TEST.clk);
        // TEST_1 
        enc_TEST.rst = 0 ;
        // TEST_2 
        for (D_count = 0 ; D_count < 17 ; D_count = D_count + 1 ) begin
            @(posedge enc_TEST.clk);
            enc_TEST.D = D_count ;
            $display ("D = %b , Y = %b , enc_TEST.valid = %b" , enc_TEST.D , enc_TEST.Y , enc_TEST.valid) ;
        end
        $stop ;
    end
endmodule