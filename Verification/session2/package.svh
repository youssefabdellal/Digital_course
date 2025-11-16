package counter_package;
    parameter WIDTH = 4 ;
    class counter_class;
        rand logic load_n;
        rand logic rst_n ;
        rand logic up_down;
        rand logic ce ;
        rand logic [3:0] data_load ;

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
    endclass
endpackage 