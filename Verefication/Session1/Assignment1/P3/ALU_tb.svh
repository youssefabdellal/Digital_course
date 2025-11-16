module ALU_tb ();
    reg signed [3:0] A ,B ;
    reg clk ;
    reg rst ;
    reg [1:0] opcode ;
    wire [4:0] C ;

    localparam MAXPOS = 7 ;
    localparam MAXNEG = -8 ;

    integer error_count , correct_count ;

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    ALU_4_bit DUT (clk,rst,opcode,A,B,C) ;

    initial begin
        rst = 0 ;
        A = 0 ;
        B = 0 ;
        correct_count = 0 ;
        error_count = 0 ;
        opcode = 0 ;
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
        opcode = 1 ;
        A = MAXPOS ;
        B = 0 ;
        check_result (7) ;
        // TEST_12
        B = MAXPOS ;
        check_result (0) ;
        // TEST_13
        B = MAXNEG ;
        check_result (15) ;
        // TEST_14
        A = MAXNEG;
        B = 0 ;
        check_result (-8) ;
        // TEST_15
        B = MAXPOS ;
        check_result (-15) ;
        // TEST_16
        B = MAXNEG ;
        check_result (0) ;
        // TEST_17
        A = 0 ;
        B = 0 ;
        check_result (0) ;
        // TEST_18
        B = MAXPOS ;
        check_result (-7) ;
        // TEST_19
        B = MAXNEG ;
        check_result (8) ;
        // TEST_20
        opcode = 2 ;
        repeat (10)  begin
            A = $random ;
            check_result (~A) ;
        end
        // TEST_21
        opcode = 3 ;
        repeat (10)  begin
            B = $random ;
            check_result (|B) ;
        end
        // TEST_22
        A = $random ;
        B = $random ;
        opcode = 0 ;
        check_result (A+B) ;
        // TEST_23
        opcode = 1 ;
        check_result (A-B) ;
        // TEST_24
        opcode = 2 ;
        check_result (~A) ;
        // TEST_25
        opcode = 3 ;
        check_result (|B) ;
        // TEST_26
        opcode = 2'bxx ;
        check_result (0);
        // TEST_27
        assert_reset();
        
        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task check_result (input signed [4:0] expected_out);
        @ (negedge clk) ;
        if (opcode == 0 || opcode == 1) begin
            if (C == expected_out) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ;        
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end
        end
        else if (opcode == 2) begin
            if (C == expected_out) begin
            $display ("test passes") ;
                correct_count = correct_count + 1 ;        
            end
            else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end 
        end
        else begin
            if (C == expected_out) begin
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
        check_result (0) ;
        rst = 0 ;
    endtask

endmodule