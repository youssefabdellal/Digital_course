module DFF_test2();
    reg clk ;
    reg rst ;
    reg d   ;
    reg en  ;
    wire q  ;

    integer error_count , correct_count ; 

    dff #(.USE_EN(0)) DUT (clk, rst, d, q, en) ;

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end
    
    initial begin
        rst = 0 ;
        en  = 0 ;
        d   = 1 ;
        correct_count = 0 ;
        error_count   = 0 ;
        // TEST_1
        assert_reset () ;
        // TEST_2
        repeat (10) begin
            en = 0 ;
            d  = $random ;
            check_result () ;
        end
        // TEST_3
        repeat (10) begin
            en = 1 ;
            d  = $random ;
            check_result () ;
        end
        // TEST_4
        repeat (10) begin
            en = $random ;
            d  = $random ;
            check_result () ;
        end
        // TEST_5
        assert_reset () ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;

    end

    task check_result ();
        @ (negedge clk) ;
            if (q == d) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ;  
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
    endtask

    task assert_reset ();
        rst = 1 ;
        @ (negedge clk) ;
        if (q == 0 ) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;  
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end
        rst = 0 ;
    endtask
endmodule