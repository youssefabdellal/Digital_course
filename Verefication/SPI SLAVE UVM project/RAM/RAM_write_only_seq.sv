package RAM_write_only_seq_pkg ;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_write_only_seq extends uvm_sequence #(RAM_seq_item) ;
    `uvm_object_utils(RAM_write_only_seq)

    RAM_seq_item seq_item ;

    function new (string name = "RAM_write_only_seq");
        super.new(name);
    endfunction

    task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");
        repeat(10000) begin
            start_item(seq_item);

            seq_item.constraint_mode(0);
            seq_item.c_rx.constraint_mode(1);
            seq_item.c_rst.constraint_mode(1);
            seq_item.c_write_only.constraint_mode(1);
            assert (seq_item.randomize());
            
            finish_item(seq_item);
        end
    endtask 
 endclass
endpackage