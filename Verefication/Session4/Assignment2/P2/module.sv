module P2();
    bit requst ;
    bit grant ;
    bit clk ;
    bit frame ;
    bit irdy ;
    bit request ;

    property assert1;
        @(posedge clk) $rose(request) |=> ##[2:5] (grant) ;
    endproperty

    property assert2;
        @(posedge clk) $rose(grant) |-> ($fell(frame) && $fell(irdy)) ;
    endproperty

    property assert3;
        @(posedge clk) ($rose(frame) && $rose(irdy)) |=> ($fell(grant)) ;
    endproperty
endmodule