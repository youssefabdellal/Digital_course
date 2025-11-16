package wrapper_test_pkg;
  import SLAVE_env_pkg::*;
  import SLAVE_config_pkg::*;
  import RAM_env_pkg::*;
  import pkg_cfg::*;
  import wrapper_env_pkg::*;
  import wrapper_config_pkg::*;
  import wrapper_reset_seq_pkg::*;
  import uvm_pkg::*;
  import wrapper_read_only_seq_pkg::*;
  import wrapper_write_only_seq_pkg::*;
  import wrapper_read_write_seq_pkg::*;
  `include "uvm_macros.svh"

  class wrapper_test extends uvm_test;
    `uvm_component_utils(wrapper_test)
    wrapper_env env ;
    wrapper_config wrapper_cfg ;
    wrapper_reset_seq rst_seq;
    RAM_env env_ram ;
    SLAVE_env env_slave ;
    SLAVE_config slave_cfg ;
    RAM_config_obj ram_cfg ;
    wrapper_read_only_seq ro_seq;
    wrapper_write_only_seq wo_seq;
    wrapper_read_write_seq rw_seq;

      function new (string name = "wrapper_test" , uvm_component parent = null);
        super.new (name , parent) ;
      endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase) ;
      env = wrapper_env::type_id::create("env",this);
      env_ram = RAM_env::type_id::create("env_ram",this);
      env_slave = SLAVE_env::type_id::create("env_slave",this);
      wrapper_cfg = wrapper_config::type_id::create("wrapper_cfg");
      ram_cfg = RAM_config_obj::type_id::create("ram_cfg");
      slave_cfg = SLAVE_config::type_id::create("slave_cfg");
      rst_seq = wrapper_reset_seq::type_id::create("rst_seq");
      ro_seq = wrapper_read_only_seq::type_id::create("ro_seq");
      wo_seq = wrapper_write_only_seq::type_id::create("wo_seq");
      rw_seq = wrapper_read_write_seq::type_id::create("rw_seq");

      if (!uvm_config_db #(virtual wrapper_if)::get(this, "" , "WRAPPER_IF" , wrapper_cfg.wrapper_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual interface");

      if(!uvm_config_db #(virtual SLAVE_if)::get(this, "" , "SLAVE_IF" , slave_cfg.SLAVE_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual interface of SLAVE");

      if(!uvm_config_db #(virtual RAM_if)::get(this, "" , "RAM_IF" , ram_cfg.RAM_config_vif))
        `uvm_fatal("build_phase" , "TEST - unable to get the virtual interface of RAM");

      ram_cfg.is_active = UVM_PASSIVE;
      slave_cfg.is_active = UVM_PASSIVE;
      wrapper_cfg.is_active = UVM_ACTIVE;

      // Set config objects with correct keys that agents expect
      uvm_config_db #(RAM_config_obj)::set(this , "*" , "CFG" , ram_cfg);
      uvm_config_db #(SLAVE_config)::set(this , "*" , "CFG" , slave_cfg);
      uvm_config_db #(wrapper_config)::set(this , "*" , "CFG" , wrapper_cfg);

    endfunction
    
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("run_phase", "reset asserted" , UVM_MEDIUM)
      rst_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "reset deasserted" , UVM_MEDIUM)
      
      `uvm_info("run_phase", "write only sequence started" , UVM_MEDIUM)
      wo_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "write only sequence finished" , UVM_MEDIUM)

      `uvm_info("run_phase", "read only sequence started" , UVM_MEDIUM)
      ro_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "read only sequence finished" , UVM_MEDIUM)

      `uvm_info("run_phase", "read/write sequence started" , UVM_MEDIUM)
      rw_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "read/write sequence finished" , UVM_MEDIUM)

      phase.drop_objection(this);
    endtask
  endclass

endpackage