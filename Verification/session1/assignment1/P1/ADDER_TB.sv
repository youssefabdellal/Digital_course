module adder_tb();
    reg  clk;
    reg  reset;
    reg  signed [3:0] A;	
    reg  signed [3:0] B;	
    wire signed [4:0] C;

    integer error_count , correct_count ;

    localparam MAXPOS = 7 ;
    localparam MAXNEG = -8 ;

    adder DUT (clk,reset,A,B,C) ;

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    initial begin 
        A = 0 ;
        B = 4 ;
        reset = 0 ;
        error_count = 0 ;
        correct_count = 0 ;
        // TEST_1
        assert_reset () ;
        // TEST_2 
        A = MAXPOS ;
        B = 0 ;
        check_result (7) ;
        // TEST_3
        B = MAXPOS ;
        check_result (14) ;
        // TEST_4
        B = MAXNEG ;
        check_result (-1) ;
        // TEST_5 
        A = MAXNEG;
        B = 0 ;
        check_result (-8) ;
        // TEST_6
        B = MAXPOS ;
        check_result (-1) ;
        // TEST_7
        B = MAXNEG ;
        check_result (-16) ;
        // TEST_8
        A = 0 ;
        B = 0 ;
        check_result (0) ;
        // TEST_9
        B = MAXPOS ;
        check_result (7) ;
        // TEST_10
        B = MAXNEG ;
        check_result (-8) ;
        // TEST_11 
        repeat (10) begin
            A = MAXPOS ;
            B = $random;
            check_result (A+B) ;
        end
        // TEST_12
        repeat (10) begin
            A = MAXNEG ;
            B = $random;
            check_result (A+B) ;
        end
        // TEST_13
        repeat (10) begin
            A = 0 ;
            B = $random;
            check_result (A+B) ;
        end
        // TEST_14
        repeat (10) begin
            A = $random ;
            B = MAXPOS;
            check_result (A+B) ;
        end
        // TEST_15
        repeat (10) begin
            A = $random ;
            B = MAXNEG;
            check_result (A+B) ;
        end
        // TEST_16
        repeat (10) begin
            A = $random ;
            B = 0;
            check_result (A+B) ;
        end
        // TEST_17
        repeat (10) begin
            A = $random ;
            B = $random ;
            check_result (A+B) ;
        end
        // TEST_18
        assert_reset () ;
        
        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end  
        
    task check_result (input signed [4:0] expected_out);
        @ (negedge clk) ;
        if (C == expected_out) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;        
        end
        else begin
           $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end
    endtask

    task assert_reset ();
        reset = 1 ;
        check_result (0) ;
        reset = 0 ;
    endtask

endmodule
