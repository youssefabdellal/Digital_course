package SLAVE_env_pkg;
  import SLAVE_scoreboard_pkg::*;
  import SLAVE_agent_pkg::*;
  import SLAVE_coverage_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class SLAVE_env extends uvm_env;

    `uvm_component_utils(SLAVE_env)
    SLAVE_agent agt ;
    SLAVE_coverage cov ;
    SLAVE_scoreboard sb ;

    function new (string name = "SLAVE_env" , uvm_component parent = null);
      super.new(name , parent) ;
    endfunction
  
    function void build_phase (uvm_phase phase);
      super.build_phase(phase) ;
      agt = SLAVE_agent::type_id::create("agt",this);
      cov = SLAVE_coverage::type_id::create("cov",this);
      sb  = SLAVE_scoreboard::type_id::create("sb",this);
    endfunction

    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase) ;
      agt.agt_ap.connect(sb.sb_export);
      agt.agt_ap.connect(cov.cov_export);
    endfunction
  endclass
endpackage