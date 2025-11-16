import SHARED_pkg::*;
package FIFO_transaction_pkg;
    class FIFO_transaction ;
        logic clk ;
        rand logic [SHARED_pkg::FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [SHARED_pkg::FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        integer RD_EN_ON_DIST , WR_EN_ON_DIST ;

        function new (int a = 40 , int b = 60);
            RD_EN_ON_DIST = a ;
            WR_EN_ON_DIST = b ;
        endfunction 

        constraint reset {
            rst_n dist {1:/97 , 0:/3};
        }

        constraint write_enable {
            wr_en dist {1:/WR_EN_ON_DIST , 0:/100-WR_EN_ON_DIST};
        }

        constraint read_enable {
            rd_en dist {1:/RD_EN_ON_DIST , 0:/100-RD_EN_ON_DIST};
        }

    endclass
endpackage