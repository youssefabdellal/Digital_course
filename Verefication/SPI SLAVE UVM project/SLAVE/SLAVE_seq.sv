package SLAVE_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_item_pkg::*;
    class SLAVE_seq extends uvm_sequence #(SLAVE_item);
        `uvm_object_utils(SLAVE_seq)
        SLAVE_item seq_item ;
        
        function new(string name = "SLAVE_seq");
            super.new(name);
        endfunction 

        task body;
            seq_item = SLAVE_item ::type_id::create("seq_item");
            repeat (10000) begin
            start_item(seq_item);
            assert(seq_item.randomize);
            finish_item(seq_item);
            end
        endtask
    endclass
endpackage