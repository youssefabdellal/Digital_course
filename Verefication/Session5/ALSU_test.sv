package ALSU_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_env_pkg::*;
    import ALSU_config_pkg::*;

    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test)
        ALSU_env env ;
        ALSU_config_obj alsu_config_obj_test;

        function new(string name = "ALSU_test" , uvm_component parent = null);
            super.new(name , parent) ;
        endfunction 

        function void build_phase (uvm_phase phase);
            super.build_phase(phase) ;
            env = ALSU_env::type_id::create("env",this);
            alsu_config_obj_test = ALSU_config_obj::type_id::create("alsu_config_obj_test");

            if (!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_if",alsu_config_obj_test.alsu_config_vif))
                `uvm_fatal("build_phase" , "TEST - unable to get the virtual intrface");

            uvm_config_db #(ALSU_config_obj)::set(this,"*","TEST",alsu_config_obj_test);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase (phase);
            phase.raise_objection (this) ;
            #100;
            `uvm_info ("run_phase" , "“Inside the ALSU test”" , UVM_MEDIUM) 
            phase.drop_objection (this) ;
        endtask
    endclass 
endpackage