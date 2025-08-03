module DSP48A1_tb();
    // input signals
    reg [17:0] A;
    reg [17:0] B;
    reg [47:0] C;
    reg [17:0] D;
    reg [17:0] BCIN;
    reg [47:0] P_expected;
    reg  [47:0] PCIN;
    reg CARRYOYT_expected;
    // output signals
    wire CARRYOUTF;
    wire CARRYOUT;
    wire [35:0]M;
    wire [47:0]P;
    wire [17:0] BCOUT;
    wire [47:0] PCOUT;
    // control signals
    reg CARRYIN ;
    reg [7:0] OPMODE;
    // enable signals
    reg clk;
    reg CEA;
    reg CEB;
    reg CEC;
    reg CED;
    reg CEM;
    reg CEP;
    reg CECARRYIN;
    reg CEOPMODE;
    // reset signals 
    reg RSTA;
    reg RSTB;
    reg RSTC;
    reg RSTD;
    reg RSTM;
    reg RSTP;
    reg RSTCARRYIN;
    reg RSTOPMODE;

    DSP48A1 #(
    .A0REG(0),.A1REG(1),.B0REG(0),.B1REG(1),
    .CREG(1),.DREG(1),.MREG(1),.PREG(1),
    .CARRYINREG(1),.CARRYOUTREG(1),.OPMODEREG(1),
    .CARRYINSEL("OPMODE5"),.B_INPUT("DIRECT"),.RSTTYPE("SYNC")
    ) DUT (.A(A),.B(B),.C(C),.D(D),.BCIN(BCIN),.M(M),.P(P),
    .CARRYOUT(CARRYOUT),.CARRYOUTF(CARRYOUTF),.CARRYIN(CARRYIN),
    .OPMODE(OPMODE),.clk(clk),.CEA(CEA),.CEB(CEB),
    .CEC(CEC),.CED(CED),.CEM(CEM),.CEP(CEP),
    .CECARRYIN(CECARRYIN),.CEOPMODE(CEOPMODE),
    .RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),.RSTD(RSTD),
    .RSTM(RSTM),.RSTP(RSTP),.RSTCARRYIN(RSTCARRYIN),
    .RSTOPMODE(RSTOPMODE),.PCIN(PCIN),.BCOUT(BCOUT),.PCOUT(PCOUT)
    );
    // clock generation 
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end

    initial begin
    // 2.1. verify Reset operation
        // Assert all active-high reset signals by setting them to 1.
        RSTA = 1;
        RSTB = 1;
        RSTC = 1;
        RSTD = 1;
        RSTM = 1;
        RSTP = 1;
        RSTOPMODE = 1;
        RSTCARRYIN = 1;
        A = $random ;
        B = $random ;
        C = $random ;
        D = $random ;
        CARRYIN = $random ;
        OPMODE = $random ;
        CEA = $random ;
        CEB = $random ;
        CEC = $random ;
        CED = $random ;
        CEM = $random ;
        CEP = $random ;
        CEOPMODE = $random ;
        CECARRYIN = $random ;
        PCIN = $random ;
        P_expected = 0;
        CARRYOYT_expected = 0 ;
        @ (negedge clk) ;
        if (P == P_expected && M == 0 && BCOUT == 0 && CARRYOUT == CARRYOYT_expected)
        $display ("Verify Reset Operation sucsseful");
        else 
        $display ("Verify Reset Operation failed");
    // 2.2. Verify DSP Path 1
        RSTA = 0;
        RSTB = 0;
        RSTC = 0;
        RSTD = 0;
        RSTM = 0;
        RSTP = 0;
        RSTOPMODE = 0;
        RSTCARRYIN =0;
        CEA = 1 ;
        CEB = 1 ;
        CEC = 1 ;
        CED = 1 ;
        CEM = 1 ;
        CEP = 1 ;
        CEOPMODE = 1;
        CECARRYIN= 1;
        A = 20 ;
        B = 10 ;
        C = 350;
        D = 25 ;
        OPMODE = 8'b11011101;
        P_expected = 'h32 ;
        CARRYOYT_expected = 0 ; 
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;
        repeat (4) @ (negedge clk);
        if ((BCOUT == 'hf) && 
            (M == 'h12c) && 
            (P == P_expected) && 
            (PCOUT == P_expected) && 
            (CARRYOUT == CARRYOYT_expected) && 
            (CARRYOUTF == CARRYOYT_expected))
        $display ("TEST path1 sucsseful");
        else 
        $display ("TEST path1 failed");
    // 2.3. Verify DSP Path 2
        OPMODE = 8'b00010000;
        P_expected = 0 ;
        CARRYOYT_expected = 0 ;
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;
        repeat (3) @ (negedge clk);
        if ((BCOUT == 'h23) && 
            (M == 'h2bc) && 
            (P == P_expected) && 
            (PCOUT == P_expected) && 
            (CARRYOUT == CARRYOYT_expected) && 
            (CARRYOUTF == CARRYOYT_expected))
        $display ("TEST path2 sucsseful");
        else 
        $display ("TEST path2 failed");
    // 2.4. Verify DSP Path 3
        P_expected = P ;
        CARRYOYT_expected = CARRYOUT ;
        OPMODE = 8'b00001010;
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;
        repeat (3) @ (negedge clk);
        if ((BCOUT == 'ha) && 
            (M == 'hc8) && 
            (P == P_expected) && 
            (PCOUT == P_expected) && 
            (CARRYOUT == CARRYOYT_expected) && 
            (CARRYOUTF == CARRYOYT_expected))
        $display ("TEST path3 sucsseful");
        else 
        $display ("TEST path3 failed");
    // 2.5. Verify DSP Path 4
        A = 5  ;
        B = 6  ;
        C = 350;
        D = 25 ;
        PCIN = 3000;
        P_expected = 'hfe6fffec0bb1 ;
        CARRYOYT_expected = 1 ;
        OPMODE = 8'b10100111;
        BCIN = $random;
        CARRYIN = $random;
        repeat (3) @ (negedge clk);
        if ((BCOUT == 'h6) && 
            (M == 'h1e) && 
            (P == P_expected) && 
            (PCOUT == P_expected) && 
            (CARRYOUT == CARRYOYT_expected) && 
            (CARRYOUTF == CARRYOYT_expected))
        $display ("TEST path4 sucsseful");
        else 
        $display ("TEST path4 failed");
        $stop;
        end
endmodule