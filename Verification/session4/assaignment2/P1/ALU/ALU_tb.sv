import ALU_package::*;
module ALU_tb (ALU_if.TEST ALU_tb);
    localparam MAXPOS = 7 ;
    localparam MAXNEG = -8 ;

    initial begin
        ALU_class obj1 = new ;
        // TEST_1 
        ALU_tb.reset = 1 ;
        @(negedge ALU_tb.clk );
        // TEST_2 
        ALU_tb.reset = 0 ;
        repeat (100) begin
            @(posedge ALU_tb.clk );
            assert (obj1.randomize()) else $fatal("Randomization failed");
            ALU_tb.reset     = obj1.rst       ;
            ALU_tb.A         = obj1.A         ;
            ALU_tb.B         = obj1.B         ;
            ALU_tb.opcode    = obj1.opcode    ;
        end
        $stop ;
    end
endmodule