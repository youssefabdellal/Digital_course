package SLAVE_test_pkg;
  import SLAVE_env_pkg::*;
  import SLAVE_config_pkg::*;
  import SLAVE_reset_seq_pkg::*;
  import SLAVE_seq_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class SLAVE_test extends uvm_test;
    `uvm_component_utils(SLAVE_test)
    SLAVE_env env ;
    SLAVE_config SLAVE_cfg ;
    SLAVE_seq seq;
    SLAVE_seq_reset rst_seq;

      function new (string name = "SLAVE_test" , uvm_component parent = null);
        super.new (name , parent) ;
      endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase) ;
      env = SLAVE_env::type_id::create("env",this);
      SLAVE_cfg = SLAVE_config::type_id::create("SLAVE_cfg");
      seq = SLAVE_seq::type_id::create("seq");
      rst_seq = SLAVE_seq_reset::type_id::create("rst_seq");
      
      if (!uvm_config_db #(virtual SLAVE_if)::get(this, "" , "SLAVE_if" , SLAVE_cfg.SLAVE_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual intrface");

      uvm_config_db #(SLAVE_config)::set(this , "*" , "CFG" , SLAVE_cfg);

    endfunction
    
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "reset asserted" , UVM_MEDIUM)
      rst_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "reset deasserted" , UVM_MEDIUM)

      `uvm_info("run_phase", "seq stimulis generated started " , UVM_MEDIUM)
      seq.start(env.agt.sqr);
      `uvm_info("run_phase", "seq stimulis generated ended" , UVM_MEDIUM)

      phase.drop_objection(this);
    endtask: run_phase
  endclass

endpackage