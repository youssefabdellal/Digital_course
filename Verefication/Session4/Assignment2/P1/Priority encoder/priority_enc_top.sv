module priority_enc_top();
    bit clk ;
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    priority_enc_if inst_interface (clk) ;
    priority_enc inst_design (inst_interface) ;
    priority_enc_tb inst_tb (inst_interface) ;
    bind priority_enc priority_enc_sva inst_sva (.enc_sva(enc_DUT)) ;
endmodule