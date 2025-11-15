module priority_enc_tb();
    reg [3:0] D ;
    reg clk ;
    reg rst ;
    wire [1:0] Y ;
    wire valid ;

    integer error_count , correct_count ;
    integer D_count ;

    priority_enc DUT (clk,rst,D,Y,valid);

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    initial begin
        D = 4 ;
        rst = 0 ;
        error_count = 0 ;
        correct_count = 0 ;
        // TEST_1 
        assert_reset () ;
        $display ("D = %b , Y = %b , valid = %b" , D , Y , valid) ;
        // TEST_2 
        for (D_count = 0 ; D_count < 17 ; D_count = D_count + 1 ) begin
            D = D_count ;
            check_result () ;
            $display ("D = %b , Y = %b , valid = %b" , D , Y , valid) ;
        end
        // TEST_3
        assert_reset () ;
        $display ("D = %b , Y = %b , valid = %b" , D , Y , valid) ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;

    end

    task check_reset ();
        @ (negedge clk) ;
        if (Y == 0 ) begin
           $display ("test reset passes") ;
           correct_count = correct_count + 1 ; 
        end
        else begin
                $display ("test reset  fail ") ;
                error_count = error_count + 1 ; 
            end
    endtask

    task check_result ();
        @ (negedge clk) ;
        if (D == 0 ) begin
            if ( valid == 0 ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ; 
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
        else if (D[0] == 1) begin
            if (Y == 3 && valid == 1 ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ; 
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
        else if (D[1] == 1) begin
            if (Y == 2 && valid == 1 ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ; 
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
        else if (D[2] == 1) begin
            if (Y == 1 && valid == 1 ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ; 
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
        else if (D[3] == 1) begin
            if (Y == 0 && valid == 1 ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ; 
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
    endtask

    task assert_reset ();
        rst = 1 ;
        // expected_out = 0 ;
        check_reset () ;
        rst = 0 ;
    endtask


endmodule