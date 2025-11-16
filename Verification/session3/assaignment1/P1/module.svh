import testing_pkg::*;
module ALU_tb();
    Transaction obj = new ;
    byte operand1 , operand2 ;
    bit clk , rst ;
    opcode_e opcode ;
    byte out ;
    byte expected_out ;


    alu_seq DUT (operand1, operand2, clk, rst, opcode, out) ;

    integer correct_count , error_count ;

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
            obj.clk = clk;
        end
    end

    initial begin
        rst = 0 ;
        correct_count = 0 ;
        error_count = 0 ;
        check_result () ;
        repeat (30000) begin
            assert (obj.randomize()) ;
            operand1 = obj.operand1 ;
            operand2 = obj.operand2 ;
            opcode   = obj.opcode   ;
            golden_model () ;
            check_result () ;
        end

        check_result() ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task golden_model ();
        if (rst) 
            expected_out = 0 ;
        else begin
            case (opcode)
                ADD : expected_out = operand1 + operand2 ;
                SUB : expected_out = operand1 - operand2 ;
                MULT: expected_out = operand1 * operand2 ;
                DIV : expected_out = operand1 / operand2 ;
            endcase
        end
    endtask

    task check_result ();
        @(negedge clk) ;
        if (expected_out == out) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;  
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end  
    endtask

    task assert_reset();
        rst = 1 ;
        expected_out = 0 ;
        @(negedge clk) ;
        if (expected_out == out) begin
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