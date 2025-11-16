import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_test_pkg::*;

module ALSU_top();
    bit clk;
    initial begin
        clk = 0 ;
        forever begin
            #1 clk = ~clk ;
        end
    end

    ALSU_if inst_if (clk) ;
    ALSU inst_DUT (inst_if.A, inst_if.B, inst_if.cin, 
                    inst_if.serial_in, inst_if.red_op_A, 
                        inst_if.red_op_B, inst_if.opcode, 
                            inst_if.bypass_A, inst_if.bypass_B, 
                                inst_if.clk, inst_if.rst, inst_if.direction, 
                                    inst_if.leds, inst_if.out);
    
    initial begin
        uvm_config_db #(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_if",inst_if) ;
        run_test ("ALSU_test") ;
    end
endmodule