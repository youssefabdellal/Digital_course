package SLAVE_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_item_pkg::*;
    class SLAVE_sequencer extends uvm_sequencer #(SLAVE_item);
        `uvm_component_utils(SLAVE_sequencer)
        
        function new(string name = "SLAVE_sequencer" , uvm_component parent = null );
            super.new(name, parent);
        endfunction 
    endclass 
endpackage