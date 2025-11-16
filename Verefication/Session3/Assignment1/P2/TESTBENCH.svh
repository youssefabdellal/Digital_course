import counter_package::*;
module counter_tb ();
    parameter WIDTH = 4 ;
    reg clk_tb ;
    reg rst_n_tb ;
    reg load_n_tb;
    reg up_down_tb ;
    reg ce_tb ;
    reg  [WIDTH-1:0] data_load_tb ;
    reg [WIDTH-1:0] out_expected ;
    wire [WIDTH-1:0] count_out_tb ;

    wire max_count_tb ;
    wire zero_tb ;
    reg zero_flag_expected ;
    reg max_count_flag_expected ;
    counter_class obj1 = new;

    counter #(.WIDTH(4)) DUT (clk_tb ,rst_n_tb, load_n_tb, up_down_tb, ce_tb, data_load_tb, count_out_tb, max_count_tb, zero_tb);

    integer error_count , correct_count ;

    initial begin
        clk_tb = 0;
        forever begin
            #2 clk_tb = ~clk_tb;
            obj1.clk_cv = clk_tb;
        end
    end

    always @(posedge clk_tb) begin
        obj1.count_out = count_out_tb;   // mirror DUT output
        obj1.max_count = max_count_tb;
        obj1.ZERO      = zero_tb;
    end

    initial begin
        error_count = 0 ;
        correct_count = 0 ;
        zero_flag_expected = 0 ;
        max_count_flag_expected = 0 ;
        rst_n_tb = 1 ;
        // test_1 
        assert_resrt () ;
        // test_2
        repeat (1000) begin
            assert(obj1.randomize()) ;
            rst_n_tb = obj1.rst_n ;
            load_n_tb = obj1.load_n;
            ce_tb = obj1.ce ;
            up_down_tb = obj1.up_down ;
            data_load_tb = obj1.data_load ;
            golden_model () ;
            chech_result () ;
        end
        assert_resrt () ;
        // test_4 
        repeat (16) begin
            rst_n_tb   = 1 ;
            ce_tb      = 1 ;
            up_down_tb = 1 ;
            load_n_tb  = 1 ;
            golden_model () ;
            chech_result () ;
        end
        repeat (17) begin
            rst_n_tb   = 1 ;
            ce_tb      = 1 ;
            up_down_tb = 0 ;
            load_n_tb  = 1 ;
            golden_model () ;
            chech_result () ;
        end
        //test_3
        assert_resrt() ;

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end 

    task chech_result ();
        @(negedge clk_tb)
        if (out_expected == count_out_tb && zero_flag_expected == zero_tb  && max_count_flag_expected == max_count_tb ) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;  
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end   
    endtask

    task golden_model ();
        zero_flag_expected = 0 ;
        max_count_flag_expected = 0 ;
        if (!rst_n_tb) out_expected = 0 ;
        else begin
            if (load_n_tb == 0) begin
                out_expected = data_load_tb ; 
            end
            else if (ce_tb) begin
                if (up_down_tb) out_expected = out_expected + 1 ;
                else out_expected = out_expected - 1 ;
            end
        end
        if (out_expected == 15 ) max_count_flag_expected = 1 ; 
        if (out_expected == 0) zero_flag_expected  = 1 ;
    endtask

    task assert_resrt ();
        rst_n_tb = 0 ;
        golden_model () ;
        chech_result () ;
    endtask



    
    
endmodule