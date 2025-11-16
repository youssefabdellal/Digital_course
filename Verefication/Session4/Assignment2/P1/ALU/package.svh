package ALU_package ;
    localparam MAXPOS =  7 ;
    localparam MAXNEG = -8 ;
    typedef enum logic [1:0] { Add , Sub , Not_A , ReductionOR_B  } opcode_t ;
    class ALU_class;
        randc logic signed [3:0] A ,B ;
        rand logic rst ;
        randc opcode_t opcode ;
        
        constraint RESET {
            rst dist {0:/99 , 1:/1} ;
        }
        
    endclass
endpackage