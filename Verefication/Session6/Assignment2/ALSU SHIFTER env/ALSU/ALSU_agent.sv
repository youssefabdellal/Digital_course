package ALSU_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_sequencer_pkg::*;
    import ALSU_driver_pkg::*;
    import ALSU_config_pkg::*;
    import ALSU_monitor_pkg::*;
    import ALSU_item_pkg::*;

    class ALSU_agent extends uvm_agent;
        `uvm_component_utils(ALSU_agent)
        ALSU_sequencer sqr ;
        ALSU_driver drv ;
        ALSU_monitor mon;
        ALSU_config ALSU_cfg;
        uvm_analysis_port #(ALSU_item) agt_ap;

        function new(string name = "ALSU_agent" , uvm_component parent = null );
            super.new(name, parent);
        endfunction 

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(ALSU_config)::get(this, "", "CFG", ALSU_cfg)) begin
                `uvm_fatal("build_phase", "ALSU_AGENT - unable to get configuration object");
            end 
            mon = ALSU_monitor::type_id::create("mon",this);
            agt_ap = new("agt_ap",this);
            if (ALSU_cfg.is_active == UVM_ACTIVE) begin
                drv = ALSU_driver::type_id::create("drv",this);
                sqr = ALSU_sequencer::type_id::create("sqr",this);
            end 
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            mon.ALSU_vif = ALSU_cfg.ALSU_vif;
            mon.mon_ap.connect(agt_ap);
            if (ALSU_cfg.is_active == UVM_ACTIVE) begin
                drv.ALSU_vif = ALSU_cfg.ALSU_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end 
        endfunction

    endclass 
endpackage