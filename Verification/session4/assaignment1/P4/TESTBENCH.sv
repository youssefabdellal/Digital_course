import reg_buggy_pkg::*;
module reg_buggy_tb();
    reg clk ;
    reg reset;
    reg write;
    reg [15:0] data_in;
    wire [15:0] data_out;
    reg [15:0] data_out_expected;
    
    address_t address_tb ;
    logic [15:0] reset_assoc[string] ;
    logic [15:0] data_assoc[int] ;

    config_reg DUT (clk,reset,write,data_in,address_tb,data_out) ;

    integer correct_count = 0;
    integer error_count   = 0;
    
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    initial begin
        reg_buggy_class obj = new ;
        reset = 0 ;
        $display("==============testing reset 1==================");
        assert_reset() ;
            write = 1 ;
            assert (obj.randomize())
            for (int i = 0 ; i < 8 ; i++) begin
                @(negedge clk);
                address_tb = obj.address_arr[i] ;
                data_in = obj.data_in[i] ;
                golden_model();
            end
            $display("==============checking reading from meomery==============");
            write = 0 ;
            assert (obj.randomize())
            for (int i = 0 ; i < 8 ; i++) begin
                @(negedge clk);
                address_tb = obj.address_arr[i];
                golden_model();
                check_result();
            end      

        $display("==================testing reset 2====================");
        assert_reset();

        $display ("correct counter = %d , error counter = %d " , correct_count , error_count ) ;
        $stop ;
    end

    task golden_model ();
        if (reset) begin
            reset_assoc [adc0_reg] = 16'hffff;
            reset_assoc [adc1_reg] = 16'h0;
            reset_assoc [temp_sensor0_reg] = 16'h0;
            reset_assoc [temp_sensor1_reg] = 16'h0;
            reset_assoc [analog_test] = 16'habcd;
            reset_assoc [digital_test] = 16'h0;
            reset_assoc [amp_gain] = 16'h0;
            reset_assoc [digital_config] = 16'h1;
        end
        else begin
            if (write) begin
                data_assoc [address_tb] = data_in ;
            end
            else begin
                data_out_expected = data_assoc [address_tb] ;
            end 
        end
    endtask

    task assert_reset();
        reset = 1 ;
        golden_model() ;
        check_reset() ;
        reset = 0 ;
    endtask

    task check_result();
        @(negedge clk) ;
        if (data_out_expected == data_out) begin
            correct_count = correct_count + 1 ;
            $display("test passes");
        end
        else begin
           error_count = error_count + 1 ;
            $display("test %d fails expected %h but output is %h " ,address_tb ,data_out_expected , data_out) ;
        end
    endtask

    task check_reset();
        for (address_tb = address_tb.first(); address_tb != address_tb.last();address_tb = address_tb.next()) begin
            @(negedge clk) ;
            if (reset_assoc[address_tb] == data_out) begin
                correct_count = correct_count + 1 ;
                $display("test %d passes " , address_tb);
            end
            else begin
                error_count = error_count + 1 ;
                $display("test %d fails expected %h bit output is %h " , address_tb ,reset_assoc[address_tb] , data_out); 
            end
        end
        @(negedge clk) ;
        if (reset_assoc[address_tb] == data_out) begin
            correct_count = correct_count + 1 ;
            $display("test %d passes " , address_tb);
        end
        else begin
            error_count = error_count + 1 ;
            $display("test %d fails expected %h bit output is %h " , address_tb ,reset_assoc[address_tb] , data_out); 
        end
    endtask

endmodule