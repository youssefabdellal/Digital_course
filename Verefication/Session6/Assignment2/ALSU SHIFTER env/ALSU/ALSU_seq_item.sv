package ALSU_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter MAXPOS =  3 ; 
    parameter MAXNEG = -4 ;
    typedef enum logic [2:0] {
        OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7
    } opcode_t ;

    class ALSU_item extends uvm_sequence_item;
        `uvm_object_utils(ALSU_item)
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
        logic [15:0] leds;
        logic signed [5:0] out;

        function new(string name = "ALSU_item");
            super.new(name);
        endfunction

        function string convert2string(); 
            return $sformatf("%s reset = %b , A = %b , B = %b , cin = %b , serial_in = %b  , red_op_A = %b , red_op_B = %b ,
                                bypass_A = %b , bypass_B = %b , direction = %b , opcode = %b " , super.convert2string() ,
                               rst , A ,B ,cin , serial_in , red_op_A , red_op_B , bypass_A , bypass_B , direction , opcode);
        endfunction

        function string convert2string_stimuls(); 
            return $sformatf("reset = %b , A = %b , B = %b , cin = %b , serial_in = %b  , red_op_A = %b , red_op_B = %b ,
                                bypass_A = %b , bypass_B = %b , direction = %b , opcode = %b , leds = %b , out = %d  " ,
                               rst , A ,B ,cin , serial_in , red_op_A , red_op_B , bypass_A , bypass_B , direction , opcode , leds , out);
        endfunction

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

    endclass
endpackage