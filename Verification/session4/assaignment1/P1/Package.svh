package ALSU_package;
    parameter MAXPOS =  3 ; 
    parameter MAXNEG = -4 ;
    typedef enum logic [2:0] {
        OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7
    } opcode_t ;
    class ALSU_class;
        rand logic rst ;
        rand logic signed [2:0] A ;
        rand logic signed [2:0] B ;
        rand logic signed [1:0] cin ;
        rand logic serial_in ;
        rand logic red_op_A ;
        rand logic red_op_B ;
        rand logic bypass_A ;
        rand logic bypass_B ;
        rand logic direction;
        rand opcode_t opcode ;
        rand opcode_t [6] opcode_arr ;
        bit clk_cv ;

        constraint Arethmatic {
            if (opcode == ADD || opcode == MULT) {
                A dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
                B dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
            }
        }

        constraint reduction_A {
            if ( (opcode inside {XOR , OR}) && red_op_A ) {
                A dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
                        3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
                B dist {0:/100} ;
            } 
        }

        constraint reduction_B {
            if ( (opcode inside {XOR , OR}) && red_op_B ) {
                B dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
                        3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
                A dist {0:/100} ;
            } 
        }

        constraint OPCODE {
            opcode dist { [0:5] :/ 95,  [6:7] :/ 5 };
        }

        constraint BYPASS {
            bypass_A dist {0:/95 , 1:/5} ;
            bypass_B dist {0:/95 , 1:/5} ;
        }

        constraint RESET {
            rst dist {0:/99 , 1:/1} ;
        }

        constraint RED_OP {
            if (opcode == OR || opcode == XOR ) {
                red_op_A dist {0:/20 , 1:/80} ;
                red_op_B dist {0:/30 , 1:/70} ;
            }
            else {
                red_op_A dist {0:/95 , 1:/5} ;
                red_op_B dist {0:/95 , 1:/5} ;
            }
        }

        constraint OPCODE_array {
            foreach (opcode_arr[i])
                opcode_arr[i] inside {OR, XOR, ADD, MULT, SHIFT, ROTATE};

            foreach (opcode_arr[i])
                foreach (opcode_arr[j])
                  if (i != j) opcode_arr[i] != opcode_arr[j];
        }

        covergroup covcode @(posedge clk_cv);
            A_cp : coverpoint A {
                bins A_data_0             =    {  0  }    ;
                bins A_data_max           =    {MAXPOS}   ;
                bins A_data_min           =    {MAXNEG}   ;
                bins A_data_default       =    default    ;
                bins A_data_walkingones[] = {001,010,100} iff (red_op_A ) ;
            }
            B_cp : coverpoint B {
                bins B_data_0             =    {  0  }    ;
                bins B_data_max           =    {MAXPOS}   ;
                bins B_data_min           =    {MAXNEG}   ;
                bins B_data_default       =    default    ;
                bins B_data_walkingones[] = {001,010,100} iff (red_op_B) ;
            }
            ALU_CP : coverpoint opcode {
                bins Bins_shift[]    = {SHIFT , ROTATE} ;
                bins Bins_arith[]    = { ADD  ,  MULT } ;
                bins Bins_bitwise[]  = {OR , XOR} ;
                bins Bins_invalid    = {INVALID_6 , INVALID_7} ;
                bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE) ;
            }
            ALU_TRANS : coverpoint opcode {
                bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE => INVALID_6 => INVALID_7) ;
            }
            arith_A: cross A_cp  , ALU_CP {
                option.cross_auto_bin_max = 0 ;
                bins arith_zero = binsof (ALU_CP.Bins_arith) && binsof (A_cp.A_data_0) ;
                bins arith_max  = binsof (ALU_CP.Bins_arith) && binsof (A_cp.A_data_max) ;
                bins arith_min  = binsof (ALU_CP.Bins_arith) && binsof (A_cp.A_data_min) ;
            }
            arith_B: cross B_cp  , ALU_CP {
                option.cross_auto_bin_max = 0 ;
                bins arith_zero = binsof (ALU_CP.Bins_arith) && binsof (B_cp.B_data_0) ;
                bins arith_max  = binsof (ALU_CP.Bins_arith) && binsof (B_cp.B_data_max) ;
                bins arith_min  = binsof (ALU_CP.Bins_arith) && binsof (B_cp.B_data_min) ;
            }
            cin_cp: coverpoint cin iff (opcode == ADD) {
                bins zero_cin = {0} ;
                bins one_cin  = {1} ;
            }
            direction_cp : coverpoint direction iff (opcode inside {SHIFT , ROTATE}) {
                bins zero_direction = {0} ;
                bins one_direction  = {1} ;
            }
            serial_in_cp : coverpoint serial_in iff (opcode == SHIFT) {
                bins zero_serial_in  = {0} ;
                bins one__serial_in  = {1} ;
            }
            walking_one_A : cross ALU_CP , A_cp , B_cp {
                option.cross_auto_bin_max = 0 ;
                bins A_walkingones = binsof (ALU_CP.Bins_bitwise) && binsof (A_cp.A_data_walkingones) && binsof (B_cp.B_data_0) iff (red_op_A)  ;
            }
            walking_one_B : cross ALU_CP , A_cp , B_cp {
                option.cross_auto_bin_max = 0 ;
                bins B_walkingones = binsof (ALU_CP.Bins_bitwise) && binsof (B_cp.B_data_walkingones) && binsof (A_cp.A_data_0) iff (red_op_B)   ;
            }
            invalid_cp : coverpoint opcode iff (red_op_A || red_op_B) {
                bins invalid_opcode = {ADD , MULT , SHIFT , ROTATE , INVALID_6 , INVALID_7};
            }

        endgroup

        function new ();
            covcode = new () ;
        endfunction

        function  printing ();
            $display ("current opcode_arr is %d , %d , %d , %d , %d , %d  and time is %t" , opcode_arr[5] ,opcode_arr[4] , opcode_arr[3] , opcode_arr[2] , opcode_arr[1] , opcode_arr[0] , $time ) ;
            $display ("current opcode is %d and time is %t" , opcode , $time ) ;
        endfunction

        function printing2 ();
            $display ("current opcode is %d and time is %t" , opcode , $time ) ;
        endfunction

        function sampling_order();
            if (!(rst || red_op_A || red_op_B)) 
                covcode.sample() ;
        endfunction
        
    endclass
endpackage 