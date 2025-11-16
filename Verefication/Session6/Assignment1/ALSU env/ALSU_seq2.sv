package ALSU_seq_2_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_item_pkg::*;
    class ALSU_seq_2 extends uvm_sequence #(ALSU_item);
        `uvm_object_utils(ALSU_seq_2)
        ALSU_item seq_item ;
        
        function new(string name = "ALSU_seq_2");
            super.new(name);
        endfunction 

        task body;
            seq_item = ALSU_item ::type_id::create("seq_item");
            seq_item.constraint_mode (0) ;
            seq_item.OPCODE_array.constraint_mode (1) ;
            repeat (1000) begin
            start_item(seq_item);
            assert(seq_item.randomize() with {
                rst == 0;
                bypass_A == 0;
                bypass_B == 0;
                red_op_A == 0;
                red_op_B == 0;
                });
            finish_item(seq_item);
            end
        endtask
    endclass
endpackage