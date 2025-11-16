package ALSU_reset_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_item_pkg::*;
    class ALSU_seq_reset extends uvm_sequence #(ALSU_item);
        `uvm_object_utils(ALSU_seq_reset)
        ALSU_item seq_item ;

        function new(string name = "ALSU_seq_reset");
            super.new(name);
        endfunction 

        task body;
            seq_item = ALSU_item ::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 1 ;
            finish_item(seq_item);
        endtask
    endclass 
endpackage