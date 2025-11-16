package ALSU_seq_1_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_item_pkg::*;
    class ALSU_seq_1 extends uvm_sequence #(ALSU_item);
        `uvm_object_utils(ALSU_seq_1)
        ALSU_item seq_item ;
        
        function new(string name = "ALSU_seq_1");
            super.new(name);
        endfunction 

        task body;
            seq_item = ALSU_item ::type_id::create("seq_item");
            seq_item.OPCODE_array.constraint_mode (0) ;
            repeat (1000) begin
            start_item(seq_item);
            assert(seq_item.randomize);
            finish_item(seq_item);
            end
        endtask
    endclass
endpackage