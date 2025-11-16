interface priority_enc_if (input bit clk);
    logic rst ;
    logic [3:0] D ;
    logic [1:0] Y ;	
    logic valid ;
    
    modport DUT ( input rst , D , clk , output Y , valid );

    modport TEST ( input Y , valid , clk , output rst , D);
endinterface