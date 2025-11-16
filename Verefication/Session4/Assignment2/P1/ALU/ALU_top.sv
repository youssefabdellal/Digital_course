import ALU_package::*;
module ALU_top ();
    bit clk ;
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    ALU_if inst_interface (clk) ;
    ALU_4_bit inst_design (inst_interface);
    ALU_tb inst_tb (inst_interface) ;
    bind ALU_4_bit ALU_sva inst_sva (.ALU_sva(ALU_DUT)) ;
endmodule