package ALSU_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_config_pkg::*;

    class ALSU_driver extends uvm_driver;
        `uvm_component_utils(ALSU_driver) 
        virtual ALSU_if alsu_driver_vif ;
        ALSU_config_obj alsu_config_obj_driver;

        function new(string name = "ALSU_driver" , uvm_component parent = null);
            super.new(name , parent);
        endfunction 

        function void build_phase (uvm_phase phase);
            super.build_phase(phase) ;
            uvm_config_db #(ALSU_config_obj)::get(this , "" , "TEST" , alsu_config_obj_driver) ;
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase) ;
            alsu_driver_vif = alsu_config_obj_driver.alsu_config_vif ; 
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase) ;
            alsu_driver_vif.rst = 1 ;
            forever begin
                @(negedge alsu_driver_vif.clk) ;
                alsu_driver_vif.red_op_A = $random ;
                alsu_driver_vif.red_op_B = $random ;
                alsu_driver_vif.bypass_A = $random ;
                alsu_driver_vif.bypass_B = $random ;
                alsu_driver_vif.direction = $random ;
                alsu_driver_vif.serial_in = $random ;
                alsu_driver_vif.cin = $random ;
                alsu_driver_vif.opcode = $random ;
                alsu_driver_vif.A = $random ;
                alsu_driver_vif.B = $random ;
            end
        endtask
    endclass 
endpackage