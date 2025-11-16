import ALSU_package::*;
module ALSU_tb ();
    reg clk_tb ;
    reg rst_tb ;
    reg signed [2:0] A_tb ; 
    reg signed [2:0] B_tb ;
    reg signed [1:0] cin_tb ;
    reg serial_in_tb ;
    reg red_op_A_tb ;
    reg red_op_B_tb ;
    opcode_t opcode_tb;
    opcode_t opcode_prev_rotate ;
    opcode_t opcode_prev_shift ;
    reg bypass_A_tb ;
    reg bypass_B_tb ;
    reg direction_tb;
    reg invalid ;

    reg signed [5:0] out_expected ;
    reg [16] leds_expected ;


    wire [15:0] leds_tb ;
    wire signed [5:0] out_tb ;

    ALSU #(.INPUT_PRIORITY("A"),.FULL_ADDER("ON")) DUT (A_tb, B_tb, cin_tb,
                                                         serial_in_tb, 
                                                         red_op_A_tb, red_op_B_tb, 
                                                         opcode_tb, bypass_A_tb, 
                                                         bypass_B_tb, clk_tb, rst_tb, 
                                                         direction_tb, leds_tb, out_tb);

    integer error_count , correct_count ;

    initial begin
        clk_tb = 0;
        forever begin
            #2 clk_tb = ~clk_tb;
        end
    end

    initial begin
        ALSU_class obj1 = new ;
        rst_tb = 0 ;
        error_count = 0 ;
        correct_count = 0 ;
        // out_expected = 0 ;
        // leds_expected = 1 ;
        assert_reset () ;

        repeat (2000) begin
            assert (obj1.randomize())
            rst_tb       = obj1.rst       ;
            A_tb         = obj1.A         ;
            B_tb         = obj1.B         ;
            cin_tb       = obj1.cin       ;
            serial_in_tb = obj1.serial_in ;
            red_op_A_tb  = obj1.red_op_A  ;
            red_op_B_tb  = obj1.red_op_B  ;
            bypass_A_tb  = obj1.bypass_A  ;
            bypass_B_tb  = obj1.bypass_B  ;
            direction_tb = obj1.direction ;
            opcode_tb    = obj1.opcode    ;
            golden_model () ;
            check_result () ; 
            golden_model () ;
        end
    
        assert_reset () ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;

        $stop ;
    end

    task golden_model ();
    leds_expected = 0 ;
    invalid = (opcode_tb == 3'b110) || 
                 (opcode_tb == 3'b111) || 
                 ((red_op_A_tb || red_op_B_tb) && 
                  (opcode_tb != 3'b000) && (opcode_tb != 3'b001)) ;
        if (rst_tb) begin
            out_expected  = 0 ;
        end
        else if (bypass_A_tb) out_expected = A_tb;
        else if (bypass_B_tb) out_expected = B_tb;
        else if (invalid) out_expected = 0;
        else if (opcode_tb == 0) begin
            if (red_op_A_tb) out_expected = |A_tb ;
            else if (red_op_B_tb) out_expected = |B_tb ;
            else out_expected = A_tb | B_tb ;
        end
        else if (opcode_tb == 1) begin
            if (red_op_A_tb) out_expected = ^A_tb ;
            else if (red_op_B_tb) out_expected = ^B_tb ;
            else out_expected = A_tb ^ B_tb ;
        end
        else if (opcode_tb == 2) out_expected = A_tb + B_tb + cin_tb ;
        else if (opcode_tb == 3) out_expected = A_tb * B_tb ;
        else if (opcode_tb == 4) begin
            if (direction_tb) out_expected = {out_expected[4:0] , serial_in_tb } ;
            else              out_expected = {serial_in_tb , out_expected[5:1] } ;
        end
        else if (opcode_tb == 5) begin
            if (direction_tb) out_expected = {out_expected[4:0] , out_expected[5] } ;
            else              out_expected = {out_expected[0] , out_expected[5:1] } ;
        end

        if (rst_tb) leds_expected = 0 ;
        else begin
            if (invalid)
                    leds_expected = ~leds_expected;
            // else leds_expected = 0;
        end
        
    endtask

    task check_result ();
    // if (opcode_tb != ROTATE && opcode_tb != SHIFT) begin
        @(negedge clk_tb) ;
        @(negedge clk_tb) ;
        if (out_expected == out_tb && leds_expected == leds_tb) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ; 
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end 
    // end
    // else begin
    //     if (opcode_prev_rotate == ROTATE && opcode_tb == ROTATE && !invalid) begin
    //         @(negedge clk_tb) ;
    //         if (out_expected == out_tb && leds_expected == leds_tb) begin
    //             $display ("test passes") ;
    //             correct_count = correct_count + 1 ; 
    //         end
    //         else begin
    //             $display ("test fail ") ;
    //             error_count = error_count + 1 ; 
    //         end 
    //     end
    //     else if (opcode_prev_shift == SHIFT && opcode_tb == SHIFT && !invalid) begin
    //         @(negedge clk_tb) ;
    //         if (out_expected == out_tb && leds_expected == leds_tb) begin
    //             $display ("test passes") ;
    //             correct_count = correct_count + 1 ; 
    //         end
    //         else begin
    //             $display ("test fail ") ;
    //             error_count = error_count + 1 ; 
    //         end 
    //     end
    //     else begin
    //         @(negedge clk_tb) ;
    //         @(negedge clk_tb) ;
    //         if (out_expected == out_tb && leds_expected == leds_tb) begin
    //             $display ("test passes") ;
    //             correct_count = correct_count + 1 ; 
    //         end
    //         else begin
    //             $display ("test fail ") ;
    //             error_count = error_count + 1 ; 
    //         end 
    //     end
    // end
    // opcode_prev_rotate = opcode_tb ;
    // opcode_prev_shift = opcode_tb ;
    endtask

    task assert_reset ();
        rst_tb = 1 ;
        out_expected = 0 ;
        leds_expected = 0 ;
        @(negedge clk_tb) ;
        check_result () ;
        rst_tb = 0 ;
    endtask
endmodule