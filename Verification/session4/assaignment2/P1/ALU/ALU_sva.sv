module ALU_sva (ALU_if.DUT ALU_sva);
    property reset_on;
        @(posedge ALU_sva.clk) (ALU_sva.reset) |-> (ALU_sva.C == 0) ;
    endproperty

    property reset_off_add;
        @(posedge ALU_sva.clk) (!ALU_sva.reset && ALU_sva.opcode == 0) |=> (ALU_sva.C == $past(ALU_sva.A) + $past(ALU_sva.B)) ;
    endproperty

    property reset_off_sub;
        @(posedge ALU_sva.clk) (!ALU_sva.reset && ALU_sva.opcode == 1) |=> (ALU_sva.C == $past(ALU_sva.A) - $past(ALU_sva.B)) ;
    endproperty

    property reset_off_NotA;
        @(posedge ALU_sva.clk) (!ALU_sva.reset && ALU_sva.opcode == 2) |=> (ALU_sva.C == ~($past(ALU_sva.A))) ;
    endproperty

    property reset_off_orB;
        @(posedge ALU_sva.clk) (!ALU_sva.reset && ALU_sva.opcode == 3) |=> (ALU_sva.C == |($past(ALU_sva.B))) ;
    endproperty

    property default_case;
        @(posedge ALU_sva.clk) (!ALU_sva.reset && (ALU_sva.opcode != 3) && (ALU_sva.opcode != 2) && (ALU_sva.opcode != 1) && (ALU_sva.opcode != 0) ) |=> (ALU_sva.C == 0) ;
    endproperty

    assert property (reset_on) ;
    assert property (reset_off_add) ;
    assert property (reset_off_sub) ;
    assert property (reset_off_NotA);
    assert property (reset_off_orB) ;
    assert property (default_case) ;

    cover property (reset_on) ;
    cover property (reset_off_add) ;
    cover property (reset_off_sub) ;
    cover property (reset_off_NotA);
    cover property (reset_off_orB) ;
    // cover property (default_case) ;
endmodule