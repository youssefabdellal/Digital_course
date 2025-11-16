module assertion_t ();
    bit a ;
    bit b ;
    bit c ;
    bit clk;
    logic [7:0] Y ;
    bit enable ;
    logic [3:0] D ;
    bit valid ;

    property assertion1;
        @(posedge clk) a |-> ##2 (b == 1) ;
    endproperty

    property assertion2;
        @(posedge clk) (a&&b) |-> ##[1:3] c ;
    endproperty

    property assertion3;
        @(posedge clk) $rose(b) |-> ##2 !b; 
    endproperty

    property assertion4;
        @(posedge clk) enable |=> $onehot(Y) ;
    endproperty

    property assertion5;
        @(posedge clk) (!D) |=> (!valid) ;
    endproperty

    assert property (assertion1) ;
    assert property (assertion2) ;
    assert property (assertion3) ;
    assert property (assertion4) ;
    assert property (assertion5) ;
endmodule