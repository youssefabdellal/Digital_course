import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
module FIFO_top();
    bit clk ;
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end
    FIFO_if      inst_if (clk);
    FIFO_tb      inst_test (inst_if);
    FIFO         inst_DUT (inst_if);
    FIFO_monitor inst_monitor (inst_if);
endmodule