import FSM_package::*;
module FSM_tb();
    reg X_tb ;
    reg clk_tb ;
    reg rst_tb ;
    wire Y_tb ;
    wire [9:0] count_tb ;

    reg Y_expected ;
    reg [9:0] count_expected ;
    state_e cs_tb , ns_tb ;
    reg Y_passed , count_passed ;

    FSM_010 DUT (clk_tb, rst_tb, X_tb, Y_tb, count_tb) ;

    integer error_count , correct_count ;

    initial begin
        clk_tb = 0;
        forever begin
            #2 clk_tb = ~clk_tb;
        end
    end

    initial begin
        fsm_transaction obj = new ;
        rst_tb = 0 ;
        correct_count = 0 ;
        error_count = 0 ;
        assert_reset () ;

        repeat (1000) begin
            assert (obj.randomize()) else $fatal("Randomization failed");
            X_tb = obj.X ;
            rst_tb = obj.rst ;
            check_result () ;
        end

        assert_reset () ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task assert_reset ();
        rst_tb = 1 ;
        Y_expected = 0 ;
        count_expected = 0 ;
        ns_tb = IDLE ;
        @(negedge clk_tb) ;
        if (Y_expected == Y_tb && count_expected == count_tb) begin
            $display ("Test passes") ;
            correct_count = correct_count + 1 ;
        end
        else begin
            $display ("Test fails") ;
            error_count = error_count + 1 ;
        end
        rst_tb = 0 ;
    endtask

    task golden_model ();
            case (cs_tb)
                IDLE: begin
                    if (X_tb) ns_tb = IDLE ;
                    else ns_tb = ZERO ;  
                end 
                ZERO: begin
                    if (X_tb) ns_tb = ONE ;
                    else ns_tb = ZERO ;
                end
                ONE: begin
                    if (X_tb) ns_tb = IDLE ;
                    else ns_tb = STORE ;
                end
                STORE : begin
                    // count_expected = count_expected + 1 ;
                    if (X_tb) ns_tb = IDLE ;
                    else ns_tb = ZERO ;
                end
            endcase
            @(posedge clk_tb) ;
        if (rst_tb) begin
            cs_tb <= IDLE ;
            count_expected <= 0 ;
        end
        else begin
            if (cs_tb == STORE) count_expected <= count_expected + 1 ; 
            cs_tb = ns_tb ;
        end
        if (cs_tb == STORE) Y_expected = 1 ;
            else Y_expected = 0 ;
    endtask

    task check_result();
        golden_model () ;
        @(negedge clk_tb) ;
        if (Y_expected == Y_tb && count_expected == count_tb ) begin
            $display ("Test passes") ;
            correct_count = correct_count + 1 ;
        end
        else begin
            $display ("Test fails") ;
            error_count = error_count + 1 ;
        end 
    endtask
endmodule