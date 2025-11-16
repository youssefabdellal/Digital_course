package testing_pkg;
    typedef enum logic [1:0] { ADD , SUB , MULT , DIV } opcode_e;

    class Transaction;
        rand opcode_e opcode ;
        rand byte operand1 ; 
        rand byte operand2 ;
        bit clk ;

        constraint operand1_constraint {
            operand1 dist {127:/25 , 0:/25 , -128:/25 , [1:126]:/15 , [-127:-1]:/10} ; 
        }

        constraint operand2_constraint {
            operand2 dist {127:/25 , 0:/25 , -128:/25 , [1:126]:/15 , [-127:-1]:/10} ;
        }

        covergroup covcode @(posedge clk) ;
            cv1: coverpoint opcode {
                bins opbin1  = {ADD,SUB} ;
                bins opbin2  = (ADD => SUB)  ;
                bins op_ADD  = {ADD} ;
                bins op_SUB  = {SUB} ;
                bins op_MULT = {MULT} ;
                bins opbin3  = default ;
                illegal_bins invalid = {DIV} ;
            }

            cv2: coverpoint operand1 {
                bins max_pos = {127}   ;
                bins ZERO    = {0}     ;
                bins max_neg = {-128}  ;
                bins other   = default ;  
            }

            cv3: coverpoint operand2 {
                bins max_pos = {127}   ;
                bins ZERO    = {0}     ;
                bins max_neg = {-128}  ;
                bins other   = default ;  
            }

            cv4 : cross cv1 ,cv2 , cv3 {
                bins max_pos1_max_pos2_ADD  = binsof (cv1.op_ADD) && binsof (cv2.max_pos) && binsof (cv3.max_pos) ;
                bins max_pos1_max_neg2_ADD  = binsof (cv1.op_ADD) && binsof (cv2.max_pos) && binsof (cv3.max_neg) ;
                bins max_pos1_zero2_ADD     = binsof (cv1.op_ADD) && binsof (cv2.max_pos) && binsof (cv3.ZERO) ;
                bins max_neg1_max_pos2_ADD  = binsof (cv1.op_ADD) && binsof (cv2.max_neg) && binsof (cv3.max_pos) ;
                bins max_neg1_max_neg2_ADD  = binsof (cv1.op_ADD) && binsof (cv2.max_neg) && binsof (cv3.max_neg) ;
                bins max_neg1_zero2_ADD     = binsof (cv1.op_ADD) && binsof (cv2.max_neg) && binsof (cv3.ZERO) ;
                bins zero1_max_pos2_ADD     = binsof (cv1.op_ADD) && binsof (cv2.ZERO)    && binsof (cv3.max_pos) ;
                bins zero1_max_neg2_ADD     = binsof (cv1.op_ADD) && binsof (cv2.ZERO)    && binsof (cv3.max_neg) ;
                bins zero1_zero2_ADD        = binsof (cv1.op_ADD) && binsof (cv2.ZERO)    && binsof (cv3.ZERO) ;

                bins max_pos1_max_pos2_SUB  = binsof (cv1.op_SUB) && binsof (cv2.max_pos) && binsof (cv3.max_pos) ;
                bins max_pos1_max_neg2_SUB  = binsof (cv1.op_SUB) && binsof (cv2.max_pos) && binsof (cv3.max_neg) ;
                bins max_pos1_zero2_SUB     = binsof (cv1.op_SUB) && binsof (cv2.max_pos) && binsof (cv3.ZERO) ;
                bins max_neg1_max_pos2_SUB  = binsof (cv1.op_SUB) && binsof (cv2.max_neg) && binsof (cv3.max_pos) ;
                bins max_neg1_max_neg2_SUB  = binsof (cv1.op_SUB) && binsof (cv2.max_neg) && binsof (cv3.max_neg) ;
                bins max_neg1_zero2_SUB     = binsof (cv1.op_SUB) && binsof (cv2.max_neg) && binsof (cv3.ZERO) ;
                bins zero1_max_pos2_SUB     = binsof (cv1.op_SUB) && binsof (cv2.ZERO)    && binsof (cv3.max_pos) ;
                bins zero1_max_neg2_SUB     = binsof (cv1.op_SUB) && binsof (cv2.ZERO)    && binsof (cv3.max_neg) ;
                bins zero1_zero2_SUB        = binsof (cv1.op_SUB) && binsof (cv2.ZERO)    && binsof (cv3.ZERO) ;

                bins max_pos1_max_pos2_MULT  = binsof (cv1.op_MULT) && binsof (cv2.max_pos) && binsof (cv3.max_pos) ;
                bins max_pos1_max_neg2_MULT  = binsof (cv1.op_MULT) && binsof (cv2.max_pos) && binsof (cv3.max_neg) ;
                bins max_pos1_zero2_MULT     = binsof (cv1.op_MULT) && binsof (cv2.max_pos) && binsof (cv3.ZERO) ;
                bins max_neg1_max_pos2_MULT  = binsof (cv1.op_MULT) && binsof (cv2.max_neg) && binsof (cv3.max_pos) ;
                bins max_neg1_max_neg2_MULT  = binsof (cv1.op_MULT) && binsof (cv2.max_neg) && binsof (cv3.max_neg) ;
                bins max_neg1_zero2_MULT     = binsof (cv1.op_MULT) && binsof (cv2.max_neg) && binsof (cv3.ZERO) ;
                bins zero1_max_pos2_MULT     = binsof (cv1.op_MULT) && binsof (cv2.ZERO)    && binsof (cv3.max_pos) ;
                bins zero1_max_neg2_MULT     = binsof (cv1.op_MULT) && binsof (cv2.ZERO)    && binsof (cv3.max_neg) ;
                bins zero1_zero2_MULT        = binsof (cv1.op_MULT) && binsof (cv2.ZERO)    && binsof (cv3.ZERO) ;
            }
        endgroup 

        function new ();
            covcode = new () ;
        endfunction

    endclass
endpackage