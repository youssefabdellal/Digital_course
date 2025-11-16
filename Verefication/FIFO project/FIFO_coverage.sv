package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new() ;
        covergroup FIFO_cg;
            write_enable: coverpoint F_cvg_txn.wr_en ;
            read_enable : coverpoint F_cvg_txn.rd_en ;
            write_ack   : coverpoint F_cvg_txn.wr_ack ;
            overflow    : coverpoint F_cvg_txn.overflow ;
            full        : coverpoint F_cvg_txn.full ;
            empty       : coverpoint F_cvg_txn.empty;
            almostfull  : coverpoint F_cvg_txn.almostfull;
            almostempty : coverpoint F_cvg_txn.almostempty;
            underflow   : coverpoint F_cvg_txn.underflow;

            cross write_enable, read_enable, write_ack {
                illegal_bins wr_ack = binsof (write_enable) intersect{0} && binsof (write_ack) intersect{1} ;
            }
            cross write_enable, read_enable, overflow{
                illegal_bins overflow = binsof (write_enable) intersect{0} && binsof (overflow) intersect{1} ;
            }
            cross write_enable, read_enable, full{
                illegal_bins overflow = binsof (write_enable) intersect{0} && binsof (full) intersect{1} 
                                        && binsof (read_enable) intersect{1} ;
            }
            cross write_enable, read_enable, empty{
                illegal_bins overflow = binsof (write_enable) intersect{1} && binsof (empty) intersect{1};
            }
            cross write_enable, read_enable, almostfull;
            cross write_enable, read_enable, almostempty;
            cross write_enable, read_enable, underflow{
                illegal_bins underflow = binsof (read_enable) intersect{0} && binsof (underflow) intersect{1} ;
            }

        endgroup 

        function new ();
            FIFO_cg = new () ;
        endfunction

        function void sample_data (FIFO_transaction F_txn );
            F_cvg_txn = F_txn ;
            FIFO_cg.sample() ;
        endfunction

    endclass
    
endpackage