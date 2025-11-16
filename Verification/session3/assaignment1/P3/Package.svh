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
        bit [2:0] last_opcode; 
        rand opcode_t [6] opcode_arr ;
        bit clk_cv ;

        constraint Arethmatic {
            if (opcode == ADD || opcode == MULT) {
                A dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
                B dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
            }
        }

        constraint reduction_A {
            if ( (opcode == OR || opcode == XOR) && red_op_A ) {
                A dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
                        3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
                B dist {3'b000:/100} ;
            } 
        }

        constraint reduction_B {
            if ( (opcode == OR || opcode == XOR) && red_op_B ) {
                B dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
                        3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
                A dist {3'b000:/100} ;
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
                red_op_A dist {0:/80 , 1:/20} ;
                red_op_B dist {0:/70 , 1:/30} ;
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
                bins A_data_walkingones[] = {001,010,100} iff (red_op_A) ;
            }
            B_cp : coverpoint A {
                bins B_data_0             =    {  0  }    ;
                bins B_data_max           =    {MAXPOS}   ;
                bins B_data_min           =    {MAXNEG}   ;
                bins B_data_default       =    default    ;
                bins B_data_walkingones[] = {001,010,100} iff (!red_op_A && red_op_B) ;
            }
            ALU_CP : coverpoint opcode {
                bins Bins_shift[]    = {SHIFT , ROTATE} ;
                bins Bins_arith[]    = { ADD  ,  MULT } ;
                bins Bins_bitwise[]  = {OR , XOR} ;
                bins Bins_invalid    = {INVALID_6 , INVALID_7} ;
                bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE) ;
                // bins trans  = (0 => 1 => 2 => 3 => 4 => 5) ;
            }
            ALU_TRANS : coverpoint opcode {
                bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE => INVALID_6 => INVALID_7) ;
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

// package ALSU_package;
//     parameter MAXPOS =  3 ; 
//     parameter MAXNEG = -4 ;
//     typedef logic [2:0] opcode_t ;
//     class ALSU_class;
//         rand logic rst ;
//         rand logic signed [2:0] A ;
//         rand logic signed [2:0] B ;
//         rand logic signed [1:0] cin ;
//         rand logic serial_in ;
//         rand logic red_op_A ;
//         rand logic red_op_B ;
//         rand logic bypass_A ;
//         rand logic bypass_B ;
//         rand logic direction;
//         rand opcode_t opcode ;
//         bit [2:0] last_opcode; 
//         rand opcode_t [6] opcode_arr ;
//         bit clk_cv ;

//         constraint Arethmatic {
//             if (opcode == 2 || opcode == 3) {
//                 A dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
//                 B dist {-4:/25, 0:/25, 3:/25, -3:/5, -2:/5, -1:/5, 1:/5, 2:/5};
//             }
//         }

//         constraint reduction_A {
//             if ( (opcode == 0 || opcode == 1) && red_op_A ) {
//                 A dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
//                         3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
//                 B dist {3'b000:/100} ;
//             } 
//         }

//         constraint reduction_B {
//             if ( (opcode == 0 || opcode == 1) && red_op_B ) {
//                 B dist {3'b001:/25, 3'b010:/25, 3'b100:/25,
//                         3'b000:/5, 3'b011:/5, 3'b101:/5, 3'b110:/5, 3'b111:/5};
//                 A dist {3'b000:/100} ;
//             } 
//         }

//         constraint OPCODE {
//             opcode dist { [0:5] :/ 95,  [6:7] :/ 5 };
//         }

//         constraint BYPASS {
//             bypass_A dist {0:/95 , 1:/5} ;
//             bypass_B dist {0:/95 , 1:/5} ;
//         }

//         constraint RESET {
//             rst dist {0:/99 , 1:/1} ;
//         }

//         constraint RED_OP {
//             if (opcode == OR || opcode == XOR ) {
//                 red_op_A dist {0:/80 , 1:/20} ;
//                 red_op_B dist {0:/70 , 1:/30} ;
//             }
//             else {
//                 red_op_A dist {0:/95 , 1:/5} ;
//                 red_op_B dist {0:/95 , 1:/5} ;
//             }
//         }


//         constraint OPCODE_array {
//             foreach (opcode_arr[i])
//                 opcode_arr[i] inside {0, 1, 2, 3, 4, 5};

//             foreach (opcode_arr[i])
//                 foreach (opcode_arr[j])
//                   if (i != j) opcode_arr[i] != opcode_arr[j];
//         }

//         covergroup covcode @(posedge clk_cv);
//             A_cp : coverpoint A {
//                 bins A_data_0             =    {  0  }    ;
//                 bins A_data_max           =    {MAXPOS}   ;
//                 bins A_data_min           =    {MAXNEG}   ;
//                 bins A_data_default       =    default    ;
//                 bins A_data_walkingones[] = {001,010,100} iff (red_op_A) ;
//             }
//             B_cp : coverpoint A {
//                 bins B_data_0             =    {  0  }    ;
//                 bins B_data_max           =    {MAXPOS}   ;
//                 bins B_data_min           =    {MAXNEG}   ;
//                 bins B_data_default       =    default    ;
//                 bins B_data_walkingones[] = {001,010,100} iff (!red_op_A && red_op_B) ;
//             }
//             ALU_CP : coverpoint opcode {
//                 bins Bins_shift[]    = {4 , 5} ;
//                 bins Bins_arith[]    = { 2  ,  3 } ;
//                 bins Bins_bitwise[]  = {0 , 1} ;
//                 bins Bins_invalid    = {6 , 7} ;
//                 // bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE) ;
//                 bins trans  = (0 => 1 => 2 => 3 => 4 => 5) ;
//             }
//             // ALU_TRANS : coverpoint opcode_arr {
//             //     bins trans  = (OR => XOR => ADD => MULT => SHIFT => ROTATE => INVALID_6 => INVALID_7) ;
//             // }
//         endgroup

//         function new ();
//             covcode = new () ;
//         endfunction

//         function  printing ();
//             $display ("current opcode_arr is %d , %d , %d , %d , %d , %d  and time is %t" , opcode_arr[5] ,opcode_arr[4] , opcode_arr[3] , opcode_arr[2] , opcode_arr[1] , opcode_arr[0] , $time ) ;
//             $display ("current opcode is %d and time is %t" , opcode , $time ) ;
//         endfunction

//         function printing2 ();
//             $display ("current opcode is %d and time is %t" , opcode , $time ) ;
//         endfunction

//         function sampling_order();
//             if (!(rst || red_op_A || red_op_B)) 
//                 covcode.sample() ;
//         endfunction
        
//     endclass
// endpackage