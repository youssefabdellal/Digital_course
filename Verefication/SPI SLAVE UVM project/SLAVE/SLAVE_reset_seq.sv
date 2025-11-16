package SLAVE_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_item_pkg::*;
    class SLAVE_seq_reset extends uvm_sequence #(SLAVE_item);
        `uvm_object_utils(SLAVE_seq_reset)
        SLAVE_item seq_item ;

        function new(string name = "SLAVE_seq_reset");
            super.new(name);
        endfunction 

        task body;
            seq_item = SLAVE_item ::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0 ;
            finish_item(seq_item);
        endtask
    endclass 
endpackage