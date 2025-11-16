package SLAVE_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_sequencer_pkg::*;
    import SLAVE_driver_pkg::*;
    import SLAVE_config_pkg::*;
    import SLAVE_monitor_pkg::*;
    import SLAVE_item_pkg::*;

    class SLAVE_agent extends uvm_agent;
        `uvm_component_utils(SLAVE_agent)
        SLAVE_sequencer sqr ;
        SLAVE_driver drv ;
        SLAVE_monitor mon;
        SLAVE_config SLAVE_cfg;
        uvm_analysis_port #(SLAVE_item) agt_ap;

        function new(string name = "SLAVE_agent" , uvm_component parent = null );
            super.new(name, parent);
        endfunction 

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(SLAVE_config)::get(this, "", "CFG", SLAVE_cfg)) begin
                `uvm_fatal("build_phase", "AGENT - unable to get configuration object");
            end 
            sqr = SLAVE_sequencer::type_id::create("sqr",this);
            drv = SLAVE_driver::type_id::create("drv",this);
            mon = SLAVE_monitor::type_id::create("mon",this);
            agt_ap = new("agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.SLAVE_vif = SLAVE_cfg.SLAVE_vif;
            mon.SLAVE_vif = SLAVE_cfg.SLAVE_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction
    endclass 
endpackage