package ALSU_test_pkg;
  import ALSU_env_pkg::*;
  import ALSU_config_pkg::*;
  import ALSU_reset_seq_pkg::*;
  import ALSU_seq_1_pkg::*;
  import ALSU_seq_2_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class ALSU_test extends uvm_test;
    `uvm_component_utils(ALSU_test)
    ALSU_env env ;
    ALSU_config ALSU_cfg ;
    ALSU_seq_1 seq_1;
    ALSU_seq_2 seq_2;
    ALSU_seq_reset rst_seq;

      function new (string name = "ALSU_test" , uvm_component parent = null);
        super.new (name , parent) ;
      endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase) ;
      env = ALSU_env::type_id::create("env",this);
      ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg");
      seq_1 = ALSU_seq_1::type_id::create("seq_1");
      seq_2 = ALSU_seq_2::type_id::create("seq_2");
      rst_seq = ALSU_seq_reset::type_id::create("rst_seq");
      
      if (!uvm_config_db #(virtual ALSU_if)::get(this, "" , "ALSU_if" , ALSU_cfg.ALSU_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual intrface");

      uvm_config_db #(ALSU_config)::set(this , "*" , "CFG" , ALSU_cfg);

    endfunction
    
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "reset asserted" , UVM_MEDIUM)
      rst_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "reset deasserted" , UVM_MEDIUM)

      `uvm_info("run_phase", "seq_1 stimulis generated started " , UVM_MEDIUM)
      seq_1.start(env.agt.sqr);
      `uvm_info("run_phase", "seq_1 stimulis generated ended" , UVM_MEDIUM)

      `uvm_info("run_phase", "seq_2 stimulis generated started" , UVM_MEDIUM)
      seq_2.start(env.agt.sqr);
      `uvm_info("run_phase", "seq_2 stimulis generated ended" , UVM_MEDIUM)
      phase.drop_objection(this);
    endtask: run_phase
  endclass

endpackage