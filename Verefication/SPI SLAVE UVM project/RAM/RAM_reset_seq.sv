package RAM_reset_seq_pkg ;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_reset_seq extends uvm_sequence #(RAM_seq_item) ;
    `uvm_object_utils(RAM_reset_seq)

    RAM_seq_item seq_item ;

    function new (string name = "RAM_reset_seq");
        super.new(name);
    endfunction

    task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");
            start_item(seq_item);

            seq_item.constraint_mode(0);
            assert(seq_item.randomize() with { seq_item.rst_n == 0; seq_item.din[9:8] == 2'b00;});
    
            finish_item(seq_item);
    endtask 
 endclass
endpackage