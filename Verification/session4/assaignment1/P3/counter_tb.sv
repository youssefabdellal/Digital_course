import counter_package::*;
module counter_tb (counter_if.TEST c_test);
    counter_class obj1 = new;

    always_comb begin
        obj1.clk_cv = c_test.clk;
    end

    always @(posedge c_test.clk) begin
        obj1.count_out = c_test.count_out;
        obj1.max_count = c_test.max_count;
        obj1.ZERO = c_test.zero;
    end

    initial begin
        // test_1 
        c_test.rst_n = 0 ;
        // test_2
        repeat (10000) begin
            @(posedge c_test.clk);
            assert(obj1.randomize()) ;
            c_test.rst_n = obj1.rst_n ;
            c_test.load_n = obj1.load_n;
            c_test.ce = obj1.ce ;
            c_test.up_down = obj1.up_down ;
            c_test.data_load = obj1.data_load ;
        end
        // test_3
        c_test.rst_n = 0 ;

        $stop ;
    end     
endmodule