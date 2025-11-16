package SLAVE_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_item_pkg::*;
    
    class SLAVE_monitor extends uvm_monitor;
        `uvm_component_utils(SLAVE_monitor)
        virtual SLAVE_if SLAVE_vif;
        SLAVE_item rsp_seq_item;
        uvm_analysis_port #(SLAVE_item) mon_ap;

        function new (string name = "SLAVE_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = SLAVE_item::type_id::create("rsp_seq_item");
                rsp_seq_item.rst_n = SLAVE_vif.rst_n ;
                rsp_seq_item.SS_n = SLAVE_vif.SS_n ;
                rsp_seq_item.MOSI = SLAVE_vif.MOSI ;
                rsp_seq_item.tx_valid = SLAVE_vif.tx_valid ;
                rsp_seq_item.tx_data = SLAVE_vif.tx_data ;
                rsp_seq_item.rx_data = SLAVE_vif.rx_data ;
                rsp_seq_item.rx_valid = SLAVE_vif.rx_valid ;
                rsp_seq_item.MISO = SLAVE_vif.MISO ;
                @(negedge SLAVE_vif.clk);
                mon_ap.write(rsp_seq_item);
            end
        endtask
    endclass
endpackage