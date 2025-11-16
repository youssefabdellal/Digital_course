package counter_package;
    parameter WIDTH = 4 ;
    class counter_class;
        rand logic load_n;
        rand logic rst_n ;
        rand logic up_down;
        rand logic ce ;
        rand logic [3:0] data_load ;
        bit clk_cv ;
        bit [WIDTH] count_out ;
        bit max_count ;
        bit ZERO ;

        constraint rst_n_dist {
            rst_n dist {1:/95 , 0:/5} ;
        }

        constraint load_n_dist {
            load_n dist {1:/70 , 0 :/30} ;
        }

        constraint ce_dist {
            ce dist {1:/70 , 0 :/30} ; 
        }

        constraint up_down_dist {
            up_down dist {1:/70 , 0 :/30} ;
        }

        covergroup covcode @(posedge clk_cv);
            load_data_cv : coverpoint data_load iff (!load_n && rst_n) ;

            count_out_cv_1 : coverpoint count_out iff (rst_n && ce && up_down) ;

            count_out_cv_2 : coverpoint count_out iff (rst_n && ce && up_down) {
                bins overflow1 = ((1 << WIDTH) - 1 => 0 ) ;
            }

            count_out_cv_3 : coverpoint count_out iff (rst_n && ce && !up_down) ;

            count_out_cv_4 : coverpoint count_out iff (rst_n && ce && !up_down) {
                bins overflow2 = ( 0 => (1 << WIDTH) - 1 ) ;
            }

            max_count_cv   : coverpoint max_count ;

            zero_cv        : coverpoint ZERO ;

        endgroup 

        function new ();
            covcode = new () ;
        endfunction
    endclass
endpackage 