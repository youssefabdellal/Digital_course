module counter_sva(counter_if.DUT c_if);
     property load_on;
        @(posedge c_if.clk) (!c_if.load_n && c_if.rst_n) |=> (c_if.count_out == $past(c_if.data_load));
    endproperty 

    property load_enable_off;
        @(posedge c_if.clk) (c_if.load_n && !c_if.ce && c_if.rst_n) |=> (c_if.count_out == $past(c_if.count_out)) ;
    endproperty

    property load_off_enable_on_up;
        @(posedge c_if.clk) (c_if.load_n && c_if.ce && c_if.up_down && c_if.rst_n) |=> (c_if.count_out == $past(c_if.count_out) + 1'b1) ;
    endproperty

    property load_off_enable_on_down;
        @(posedge c_if.clk) (c_if.load_n && c_if.ce && !c_if.up_down && c_if.rst_n) |=> (c_if.count_out == $past(c_if.count_out) - 1'b1) ;
    endproperty

    property assert_reset;
        @(posedge c_if.clk) (!c_if.rst_n) |=> (c_if.count_out == 0) ;
    endproperty

    property max;
        @(posedge c_if.clk) (c_if.count_out == 4'b1111) |-> (c_if.max_count == 1'b1) ;
    endproperty

    property zero;
        @(posedge c_if.clk) (c_if.count_out == 1'b0) |-> (c_if.zero == 1'b1) ;
    endproperty

    assert property (load_on) ;
    assert property (load_enable_off) ;
    assert property (load_off_enable_on_up) ;
    assert property (load_off_enable_on_down) ;
    assert property (assert_reset) ;
    assert property (max) ;
    assert property (zero) ;

    cover property (load_on) ;
    cover property (load_enable_off) ;
    cover property (load_off_enable_on_up) ;
    cover property (load_off_enable_on_down) ;
    cover property (assert_reset) ;
    cover property (max) ;
    cover property (zero) ;   
endmodule