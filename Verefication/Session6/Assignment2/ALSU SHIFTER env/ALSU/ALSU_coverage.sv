package ALSU_coverage_pkg;
    import uvm_pkg::*;
    import ALSU_item_pkg::*;
    `include "uvm_macros.svh"

    class ALSU_coverage extends uvm_component;
        `uvm_component_utils(ALSU_coverage)
        uvm_analysis_export #(ALSU_item) cov_export;
        uvm_tlm_analysis_fifo #(ALSU_item) cov_fifo;
        ALSU_item seq_item_cov;

        covergroup covcode;
            A_cp : coverpoint seq_item_cov.A {
                bins A_data_0             =    {  0  }    ;
                bins A_data_max           =    {MAXPOS}   ;
                bins A_data_min           =    {MAXNEG}   ;
                bins A_data_default       =    default    ;
                bins A_data_walkingones[] = {001,010,100} iff (seq_item_cov.red_op_A ) ;
            }
            B_cp : coverpoint seq_item_cov.B {
                bins B_data_0             =    {  0  }    ;
                bins B_data_max           =    {MAXPOS}   ;
                bins B_data_min           =    {MAXNEG}   ;
                bins B_data_default       =    default    ;
                bins B_data_walkingones[] = {001,010,100} iff (seq_item_cov.red_op_B) ;
            }
            ALU_CP : coverpoint seq_item_cov.opcode {
                bins Bins_shift[]    = {SHIFT , ROTATE} ;
                bins Bins_arith[]    = { ADD  ,  MULT } ;
                bins Bins_bitwise[]  = {OR , XOR} ;
                bins Bins_invalid    = {INVALID_6 , INVALID_7} ;
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
            cin_cp: coverpoint seq_item_cov.cin iff (seq_item_cov.opcode == ADD) {
                bins zero_cin = {0} ;
                bins one_cin  = {1} ;
            }
            direction_cp : coverpoint seq_item_cov.direction iff (seq_item_cov.opcode inside {SHIFT , ROTATE}) {
                bins zero_direction = {0} ;
                bins one_direction  = {1} ;
            }
            serial_in_cp : coverpoint seq_item_cov.serial_in iff (seq_item_cov.opcode == SHIFT) {
                bins zero_serial_in  = {0} ;
                bins one__serial_in  = {1} ;
            }
            walking_one_A : cross ALU_CP , A_cp , B_cp {
                option.cross_auto_bin_max = 0 ;
                bins A_walkingones = binsof (ALU_CP.Bins_bitwise) && binsof (A_cp.A_data_walkingones) && binsof (B_cp.B_data_0) iff (seq_item_cov.red_op_A)  ;
            }
            walking_one_B : cross ALU_CP , A_cp , B_cp {
                option.cross_auto_bin_max = 0 ;
                bins B_walkingones = binsof (ALU_CP.Bins_bitwise) && binsof (B_cp.B_data_walkingones) && binsof (A_cp.A_data_0) iff (seq_item_cov.red_op_B)   ;
            }
            invalid_cp : coverpoint seq_item_cov.opcode iff (seq_item_cov.red_op_A || seq_item_cov.red_op_B) {
                bins invalid_opcode = {ADD , MULT , SHIFT , ROTATE , INVALID_6 , INVALID_7};
            }
        endgroup

        function new (string name = "ALSU_coverage" , uvm_component parent = null);
            super.new(name , parent) ;
            covcode = new() ;
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo   = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                covcode.sample();
            end
        endtask
    endclass
endpackage