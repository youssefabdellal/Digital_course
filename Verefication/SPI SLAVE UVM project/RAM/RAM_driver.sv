package pkg_driver;
    import pkg_cfg::*;  
    import seq_item_pkg::*;
    import RAM_read_only_seq_pkg::*;
    import RAM_write_only_seq_pkg::*;
    import RAM_read_write_seq_pkg::*;
    import RAM_reset_seq_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class RAM_driver extends uvm_driver#(RAM_seq_item);
        `uvm_component_utils(RAM_driver)
        
        virtual RAM_intf RAM_vif ;
        RAM_seq_item stim_seq_item ;

        function new (string name = "RAM_driver", uvm_component parent = null);
            super.new(name, parent) ;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = RAM_seq_item :: type_id ::create("stim_seq_item") ;
                seq_item_port.get_next_item(stim_seq_item);
                
                @(negedge RAM_vif.clk);
                RAM_vif.rst_n       =  stim_seq_item.rst_n ;
                RAM_vif.din         =  stim_seq_item.din ;
                RAM_vif.rx_valid    =  stim_seq_item.rx_valid ;

                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask

    endclass
endpackage