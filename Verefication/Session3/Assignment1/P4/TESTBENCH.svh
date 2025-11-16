module memory_tb();
    localparam TESTS = 100 ;
    reg [16] address_array [] ;
    reg [8] data_to_write_array [] ;
    reg [8] data_read_expect_assoc [int] ;
    reg [9] data_read_queue [$] ;
    reg clk_tb ;
    reg write_tb ;
    reg read_tb ;
    reg [8] DATA_in_tb ;
    reg [16] address_tb ;
    wire [9] DATA_out_tb ;
    reg [9] read_data_stored ;

    reg [9] expected_data_out ;

    initial begin
        clk_tb = 0;
        forever begin
            #2 clk_tb    = ~clk_tb;
        end
    end

    my_mem DUT (clk_tb , write_tb , read_tb , DATA_in_tb , address_tb , DATA_out_tb ) ;

    int correct_count , error_count ;

    initial begin
        stimuulus_gen () ;
        golden_model  () ;
        write_tb = 1 ;
        read_tb  = 0 ;
        for (int i = 0; i < TESTS; i++) begin
            address_tb = address_array [i] ;
            DATA_in_tb = data_to_write_array [i] ;
            @(negedge clk_tb);
        end
        write_tb = 0 ;
        read_tb  = 1 ;
        for (int i = 0; i < TESTS; i++) begin
            address_tb = address_array [i] ;
            check9Bits (data_read_expect_assoc[address_array[i]]) ;
            print_test_result () ;
            data_read_queue.push_back (DATA_out_tb) ;
        end
        $display("read data stored in the queue");
        for (int i = 0; i < TESTS; i++) begin
            read_data_stored = data_read_queue.pop_front() ;
            check9Bits (data_read_expect_assoc[address_array[i]]) ;
            $display("read data with index %d is %b" , i , read_data_stored);
            $display("read data expected with index %d is %b" , i , expected_data_out);
        end

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task stimuulus_gen ();
        address_array       = new[TESTS];
        data_to_write_array = new[TESTS];
        for (int i = 0; i < TESTS; i++) begin
            address_array[i]       = $random;
            data_to_write_array[i] = $random;
        end
    endtask

    task golden_model ();
        for (int i = 0; i < TESTS; i++) begin
            data_read_expect_assoc [address_array[i]] = data_to_write_array [i] ;
        end
    endtask

    task check9Bits (reg [8] data_written );
        expected_data_out = {~^data_written , data_written} ;
    endtask

    task print_test_result();
         @(negedge clk_tb);
        if (DATA_out_tb == expected_data_out) begin
            $display ("test passes") ;
            correct_count = correct_count + 1 ;  
        end
        else begin
            $display ("test fail ") ;
            error_count = error_count + 1 ; 
        end  
    endtask
endmodule