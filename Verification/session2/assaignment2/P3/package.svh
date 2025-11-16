package FSM_package;
    typedef enum logic [1:0] { IDLE , ZERO , ONE , STORE } state_e ;
    class fsm_transaction;
        rand logic X ;
        rand logic rst ;

        constraint RESET {
            rst dist {0:/97 , 1:/3} ;
        }

        constraint X_rand {
            X dist {0:/67 , 1:/33} ;
        }

    endclass
endpackage