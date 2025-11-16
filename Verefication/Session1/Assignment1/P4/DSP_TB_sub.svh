module DSP_tb_sub();
    reg [17:0] A ;
    reg [17:0] B ;
    reg [47:0] C ;
    reg [17:0] D ;
    reg [47:0] P_expected;
    reg clk ;
    reg rst_n ;
    wire [47:0] P;

    integer error_count , correct_count ;

    DSP #(.OPERATION("SUBTRACT")) DUT (A, B, C, D, clk, rst_n, P);

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    initial begin
        rst_n = 1 ;
        A = 0 ;
        B = 0 ;
        C = 0 ;
        D = 0 ;
        error_count = 0 ;
        correct_count = 0 ;
        assert_reset () ;
        repeat (1000) begin
            A = $random ;
            B = $random ;
            C = $random ;
            D = $random ;
            golden_model () ;
            check_result () ;
        end
        A = {18{1'b1}};
        B = {18{1'b1}};
        C = {48{1'b1}};
        D = {18{1'b1}};
        golden_model () ;
        check_result () ;


        assert_reset () ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task check_result ();
    // golden_model () ;
    repeat (5) @(negedge clk) ;
        if (P == P_expected ) begin
                $display ("test passes") ;
                correct_count = correct_count + 1 ;  
            end
        else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end  
    endtask

    task assert_reset ();
        rst_n = 0 ;
        @(negedge clk) ;
        if (P == 0 ) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;
        end
        else begin
                $display ("test fail ") ;
                error_count = error_count + 1 ; 
            end  
        rst_n = 1 ;
    endtask

    task golden_model ();
        P_expected = ((D-B)*A)-C ;
    endtask


endmodule