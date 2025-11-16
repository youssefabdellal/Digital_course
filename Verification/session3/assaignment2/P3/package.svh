package FSM_package;
    typedef enum logic [1:0] { IDLE , ZERO , ONE , STORE } state_e ;
    class fsm_transaction;
        rand logic X ;
        rand logic rst ;
        // state_e FSM_state ;
        bit clk_cv ;

        constraint RESET {
            rst dist {0:/97 , 1:/3} ;
        }

        constraint X_rand {
            X dist {0:/67 , 1:/33} ;
        }

        covergroup covgrp @(posedge clk_cv) ;
            cv1: coverpoint X {
                bins seq_transition = (0 => 1 => 0) ;
            }
        endgroup

        function new();
            covgrp = new() ;
        endfunction

    endclass
endpackage