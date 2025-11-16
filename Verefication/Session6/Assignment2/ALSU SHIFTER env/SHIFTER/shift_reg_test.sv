package shift_reg_test_pkg;
  import shift_reg_env_pkg::*;
  import shift_reg_config_pkg::*;
  import shift_reg_seq_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class shift_reg_test extends uvm_test;
    `uvm_component_utils(shift_reg_test)
    shift_reg_env env ;
    shift_reg_config shift_reg_cfg ;
    shift_reg_seq main_seq;

      function new (string name = "shift_reg_test" , uvm_component parent = null);
        super.new (name , parent) ;
      endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase) ;
      env = shift_reg_env::type_id::create("env",this);
      shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg");
      main_seq = shift_reg_seq::type_id::create("main_seq");
      
      if (!uvm_config_db #(virtual shift_reg_if)::get(this, "" , "shift_reg_if" , shift_reg_cfg.shift_reg_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual intrface");

      uvm_config_db #(shift_reg_config)::set(this , "*" , "shift_CFG" , shift_reg_cfg);

    endfunction
    
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "stimulis generated" , UVM_MEDIUM)
      main_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "stimulis generated" , UVM_MEDIUM)
      phase.drop_objection(this);
    endtask: run_phase
  endclass: shift_reg_test
endpackage