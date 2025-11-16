package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import SHARED_pkg::*;
    class FIFO_scoreboard;
        logic [15:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        logic [2:0] wr_ptr_test , rd_ptr_test  ;
        logic [FIFO_WIDTH-1:0] test_mem[$]; 
        logic [3:0] count_test ;

        task check_data (input FIFO_transaction txn);
            refrence_model(txn) ;
            if (txn.data_out   !== data_out_ref   ||
                txn.full       !== full_ref       ||
                txn.empty      !== empty_ref      ||
                txn.almostfull !== almostfull_ref ||
                txn.almostempty!== almostempty_ref||
                txn.overflow   !== overflow_ref   ||
                txn.underflow  !== underflow_ref  ||
                txn.wr_ack     !== wr_ack_ref) begin
                    error_count = error_count + 1 ;
                $display("test fail check the problem");
                $display("[SCOREBOARD ERROR] time=%0t DUT != REF: dout=%h/%h full=%0b/%0b empty=%0b/%0b wr_ack=%0b/%0b overflow=%0b/%0b underflow=%0b/%0b almostempty=%0b/%0b almostfull=%0b/%0b  write enable %b read enable %b count_test %d size of qeueu %d",
                 $time,
                 txn.data_out, data_out_ref,
                 txn.full, full_ref,
                 txn.empty, empty_ref,
                 txn.wr_ack, wr_ack_ref,
                 txn.overflow, overflow_ref,
                 txn.underflow, underflow_ref,
                 txn.almostempty, almostempty_ref,
                 txn.almostfull, almostfull_ref,
                 txn.wr_en , txn.rd_en , count_test , test_mem.size());
                end
            else begin
                $display("test pass");
                correct_count = correct_count + 1 ;
            end
        endtask

        task refrence_model (input FIFO_transaction txn);
            if (!txn.rst_n) begin
                wr_ptr_test  = 0 ;
                rd_ptr_test  = 0 ;
                count_test   = 0 ;
                test_mem.delete();
                overflow_ref = 0 ;
                underflow_ref = 0 ;
            end
            else begin
                if (txn.wr_en && txn.rd_en && !full_ref) begin
                    test_mem [wr_ptr_test] = txn.data_in ;
                    wr_ptr_test = wr_ptr_test + 1 ;
                    count_test  = count_test + 1 ;
                    wr_ack_ref  = 1 ;
                end
                else if (txn.wr_en && txn.rd_en && full_ref) begin
                    data_out_ref = test_mem[rd_ptr_test];
                    count_test   = count_test  - 1 ;
                    rd_ptr_test  = rd_ptr_test + 1 ;
                    wr_ack_ref   = 0; 
                    if (full_ref && txn.wr_en ) overflow_ref = 1 ;
                    else overflow_ref = 0  ; 
                end
                else begin
                    if (txn.wr_en && !txn.rd_en && !full_ref) begin
                        test_mem [wr_ptr_test] = txn.data_in ;
                        wr_ptr_test = wr_ptr_test + 1 ;
                        count_test  = count_test + 1 ;
                        wr_ack_ref  = 1 ;
                    end
                    else begin
                        wr_ack_ref = 0 ;
                        if (full_ref && txn.wr_en ) overflow_ref = 1 ;
                        else overflow_ref = 0  ;
                    end
                    if (!txn.wr_en && txn.rd_en && !empty_ref) begin
                        data_out_ref = test_mem[rd_ptr_test];
                        count_test   = count_test - 1 ;
                        rd_ptr_test  = rd_ptr_test + 1 ; 
                    end
                end  
                if (empty_ref && txn.rd_en ) underflow_ref = 1 ;
                else underflow_ref = 0  ;     
            end

            if (count_test == FIFO_DEPTH) full_ref = 1 ;
            else full_ref = 0 ;

            if (count_test == 0) empty_ref = 1 ;
            else empty_ref = 0 ;

            if (count_test == FIFO_DEPTH - 1 ) almostfull_ref = 1 ;
            else almostfull_ref = 0 ;

            if (count_test == 1) almostempty_ref = 1 ;
            else almostempty_ref = 0 ;
        endtask
    endclass
endpackage
