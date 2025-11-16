import counter_package::*;
module counter_top();
    bit clk ;
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    counter_if c_if (clk);  
    counter inst_dut(c_if);
    counter_tb inst_test(c_if);
    bind counter counter_sva assertion_inst(.c_if(c_DUT));
endmodule