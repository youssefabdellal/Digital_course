import adder_package::*;
module adder_tb();
    reg  clk;
    reg  reset;
    reg  signed [3:0] A;	
    reg  signed [3:0] B;	
    wire signed [4:0] C;
    reg  signed [4:0] expected_out;
    adder_class obj = new ;

    integer error_count , correct_count ;

    localparam MAXPOS = 7 ;
    localparam MAXNEG = -8 ;

    adder DUT (clk,reset,A,B,C) ;

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
            obj.clk_cv = clk ;
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
        repeat(1000) begin
            assert(obj.randomize()) ;
            A = obj.A_cv ;
            B = obj.B_cv ;
            reset = obj.reset_cv ;
            obj.sampling() ;
            golden_model () ;
            check_result () ;
        end
        // TEST_18
        assert_reset () ;
        
        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end  

    task golden_model();
        if (reset) expected_out = 0 ;
        else expected_out = A + B ;
    endtask
        
    task check_result ();
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
        expected_out = 0 ;
        check_result () ;
        reset = 0 ;
    endtask

endmodule