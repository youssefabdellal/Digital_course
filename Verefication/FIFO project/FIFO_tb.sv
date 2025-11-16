import FIFO_transaction_pkg::*;
import SHARED_pkg::*;
module FIFO_tb(FIFO_if.TEST FIFO_tb);
    initial begin
        FIFO_transaction obj = new ;
        FIFO_tb.rst_n = 0 ;
        @(negedge FIFO_tb.clk) ;
        @(negedge FIFO_tb.clk) ;
        FIFO_tb.rst_n = 1 ;
        repeat (90000) begin
            assert (obj.randomize());
            FIFO_tb.data_in = obj.data_in;
            FIFO_tb.wr_en   = obj.wr_en;
            FIFO_tb.rd_en   = obj.rd_en;
            @(negedge FIFO_tb.clk) ;
        end
        test_finished = 1 ;
    end
endmodule