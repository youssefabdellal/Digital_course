import ALU_package::*;
module ALU_tb ();
    reg signed [3:0] A_tb ,B_tb ;
    reg clk_tb ;
    reg rst_tb ;
    reg [1:0] opcode_tb ;
    wire signed [4:0] C_tb ;
    reg  signed [4:0] expected_out ;

    localparam MAXPOS = 7 ;
    localparam MAXNEG = -8 ;

    integer error_count , correct_count ;

    initial begin
        clk_tb = 0;
        forever begin
            #2 clk_tb = ~clk_tb;
        end
    end

    ALU_4_bit DUT (clk_tb,rst_tb,opcode_tb,A_tb,B_tb,C_tb) ;

    initial begin
        ALU_class obj1 = new ;
        rst_tb = 0 ;
        correct_count = 0 ;
        error_count = 0 ;
        // TEST_1 
        assert_reset () ;

        repeat (200) begin
            assert (obj1.randomize()) else $fatal("Randomization failed");
            rst_tb       = obj1.rst       ;
            A_tb         = obj1.A         ;
            B_tb         = obj1.B         ;
            opcode_tb    = obj1.opcode    ;
            check_result () ; 
        end

        opcode_tb = 2'bxx;
        check_result () ;

        assert_reset();
        
        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task check_result ();
        golden_model () ;
        @ (negedge clk_tb) ;
        if (expected_out == C_tb )begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;        
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end
    endtask

    task golden_model ();
        if (rst_tb) expected_out = 0 ;
        else begin
            case (opcode_tb)
                2'b00:   expected_out = A_tb + B_tb;
      	        2'b01:   expected_out = A_tb - B_tb;
      	        2'b10:   expected_out = ~A_tb;
      	        2'b11:   expected_out = |B_tb;
                default: expected_out = 5'b0; 
            endcase
        end
    endtask

    task assert_reset ();
        rst_tb = 1 ;
        @ (negedge clk_tb) ;
        if (C_tb == 0 )begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;        
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end
        rst_tb = 0 ;
    endtask

endmodule