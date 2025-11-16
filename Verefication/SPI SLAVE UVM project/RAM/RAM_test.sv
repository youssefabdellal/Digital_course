package RAM_test_pkg;
  import RAM_env_pkg::*;
  import seq_item_pkg::*;
  import RAM_sequencer_pkg::*;
  import scoreboard_pkg::*;
  import RAM_read_only_seq_pkg::*;
  import RAM_write_only_seq_pkg::*;
  import RAM_read_write_seq_pkg::*;
  import RAM_reset_seq_pkg::*;
  import pkg_cfg::*; 
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)

    RAM_config_obj RAM_cfg ;
    virtual RAM_intf RAM_vif ;
    RAM_env env ;
    RAM_read_only_seq read_only_seq ;
    RAM_write_only_seq write_only_seq ;
    RAM_read_write_seq read_write_seq ;
    RAM_reset_seq reset_seq ;
    
    function new (string name = "RAM_test", uvm_component parent = null);
      super.new(name, parent) ;
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env               = RAM_env             :: type_id :: create ("env",this) ;
      RAM_cfg           = RAM_config_obj      :: type_id :: create("RAM_cfg");
      reset_seq         = RAM_reset_seq       :: type_id :: create("reset_seq",this);
      read_only_seq     = RAM_read_only_seq   :: type_id :: create("read_only_seq",this);
      write_only_seq    = RAM_write_only_seq  :: type_id :: create("write_only_seq",this);
      read_write_seq    = RAM_read_write_seq  :: type_id :: create("read_only_seq",this);

      if (!uvm_config_db #(virtual RAM_intf)::get(this, "", "RAM_IF", RAM_cfg.RAM_config_vif))begin
        `uvm_fatal("build_phase", "test -unable to get the virtual interface");
      end 
      uvm_config_db #(RAM_config_obj)::set(this,"*", "CFG", RAM_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase) ;
      
      //reset sequence
      phase.raise_objection(this) ;
      `uvm_info("run_phase","reset_asserted",UVM_LOW)
      reset_seq.start(env.agt.sqr);
      `uvm_info("run_phase","reset_deasserted",UVM_LOW)
      phase.drop_objection(this); 
      
      // create and start write only sequence
      phase.raise_objection(this) ;
      `uvm_info("run_phase", "Starting write only sequence...", UVM_MEDIUM);
      write_only_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "write only sequence finished.", UVM_MEDIUM);
      phase.drop_objection(this); 
      
      // create and start read only sequence
      phase.raise_objection(this) ;
      `uvm_info("run_phase", "Starting read only sequence...", UVM_MEDIUM);
      read_only_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "read only sequence finished.", UVM_MEDIUM);
      phase.drop_objection(this); 
      
      // create and start read/write sequence
      phase.raise_objection(this) ;
      `uvm_info("run_phase", "Starting read/write sequence...", UVM_MEDIUM);
      read_write_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "read/write sequence finished.", UVM_MEDIUM);
      phase.drop_objection(this); 
    endtask : run_phase
  endclass: RAM_test
endpackage