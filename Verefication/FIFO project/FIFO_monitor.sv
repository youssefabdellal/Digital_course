import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_transaction_pkg::*;
import SHARED_pkg::*;
module FIFO_monitor(FIFO_if.MONITOR FIFO_mon);
    FIFO_transaction F_txn = new();
    FIFO_scoreboard  F_scb = new();
    FIFO_coverage    F_cvg = new();

    initial begin
        forever begin
            @(posedge FIFO_mon.clk);  
            #1;
            F_txn.rst_n      = FIFO_mon.rst_n;
            F_txn.wr_en      = FIFO_mon.wr_en;
            F_txn.rd_en      = FIFO_mon.rd_en;
            F_txn.data_in    = FIFO_mon.data_in;
            F_txn.data_out   = FIFO_mon.data_out;
            F_txn.full       = FIFO_mon.full;
            F_txn.empty      = FIFO_mon.empty;
            F_txn.almostfull = FIFO_mon.almostfull;
            F_txn.almostempty= FIFO_mon.almostempty;
            F_txn.overflow   = FIFO_mon.overflow;
            F_txn.underflow  = FIFO_mon.underflow;
            F_txn.wr_ack     = FIFO_mon.wr_ack;

            fork
                F_cvg.sample_data (F_txn) ;
                F_scb.check_data  (F_txn) ;
            join

            if (test_finished) begin
                $display("============================================");
                $display("           The test summary report          ");
                $display("============================================");
                $display("the corect count is %d",correct_count);
                $display("the error count is %d",error_count);
                $display("============================================");
                $stop;
            end
        end
    end
endmodule