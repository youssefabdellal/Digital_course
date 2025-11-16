package wrapper_read_write_seq_pkg ;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_read_write_seq extends uvm_sequence #(wrapper_seq_item) ;
        `uvm_object_utils(wrapper_read_write_seq)
        wrapper_seq_item seq_item ;

        function new (string name = "wrapper_read_write_seq");
            super.new(name);
        endfunction

        task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item"); 
            repeat(10000) begin
                start_item(seq_item);
                seq_item.c_read_only.constraint_mode(0);
                seq_item.c_write_only.constraint_mode(0);
                seq_item.c_read_write.constraint_mode(1);
                assert (seq_item.randomize());
                finish_item(seq_item);
            end
        endtask 
    endclass
endpackage