module DSP48A1(
    // input data ports
    input [17:0] A,
    input [17:0] B,
    input [47:0] C,
    input [17:0] D,
    input [17:0] BCIN,
    output [35:0]M,
    output [47:0]P,
    output CARRYOUT,
    output CARRYOUTF,
    // control input ports
    input CARRYIN ,
    input [7:0] OPMODE,
    // input enable ports
    input clk,
    input CEA,
    input CEB,
    input CEC,
    input CED,
    input CEM,
    input CEP,
    input CECARRYIN,
    input CEOPMODE,
    // reset input ports
    input RSTA,
    input RSTB,
    input RSTC,
    input RSTD,
    input RSTM,
    input RSTP,
    input RSTCARRYIN,
    input RSTOPMODE,
    // cascade ports
    input  [47:0] PCIN,
    output [17:0] BCOUT,
    output [47:0] PCOUT);
    // parameters 
    parameter A0REG = 0 ; // no register
    parameter A1REG = 1 ; // register
    parameter B0REG = 0 ; // no register
    parameter B1REG = 1 ; // register
    parameter CREG = 1 ;  // register
    parameter DREG = 1 ;  // register
    parameter MREG = 1 ;  // register
    parameter PREG = 1 ;  // register
    parameter CARRYINREG = 1 ;   // register
    parameter CARRYOUTREG = 1 ;  // register
    parameter OPMODEREG = 1 ;    // register
    parameter CARRYINSEL = "OPMODE5";
    parameter B_INPUT = "DIRECT";
    parameter RSTTYPE = "SYNC";
    // internal signals 
    wire [17:0]Pre_Adder_subtractor_out ;
    wire [17:0]opmode4_mux_out ;
    wire [35:0] MULTIPLICATION_OUT ;
    wire [47:0] X ;
    wire [47:0] Z ;
    wire [48:0] Post_Adder_subtractor_out ;
    wire [47:0] Post_Adder_subtractor_out_reg ;
    wire  Post_Adder_subtractor_carryout ;
    // instantion 
    // input A
    wire [17:0] A0_MUX_OUT;
    wire [17:0] A1_MUX_OUT;
    pipeline_mux  #(.WIDTH(18),.ENABLE(A0REG),.RST_MODE(RSTTYPE)) A0_REG (A,clk,A0_MUX_OUT,RSTA,CEA);
    pipeline_mux  #(.WIDTH(18),.ENABLE(A1REG),.RST_MODE(RSTTYPE)) A1_REG (A0_MUX_OUT,clk,A1_MUX_OUT,RSTA,CEA);
    // input B 
    wire [17:0] B0_MUX_OUT;  // output of the 
    wire [17:0] B1_MUX_OUT; 
    wire [17:0] BIN;
    assign BIN =(B_INPUT == "DIRECT")  ? B :
                (B_INPUT == "CASCADE") ? BCIN :
                0;
    pipeline_mux #(.WIDTH(18),.ENABLE(B0REG),.RST_MODE(RSTTYPE)) B0_REG (BIN,clk,B0_MUX_OUT,RSTB,CEB);
    pipeline_mux #(.WIDTH(18),.ENABLE(B1REG),.RST_MODE(RSTTYPE)) B1_REG (opmode4_mux_out,clk,B1_MUX_OUT,RSTB,CEB);
    // input C
    wire [47:0] C_MUX_OUT ;
    pipeline_mux  #(.WIDTH(48),.ENABLE(CREG),.RST_MODE(RSTTYPE)) C_REG (C,clk,C_MUX_OUT,RSTC,CEC);
    // input D  
    wire [17:0] D_MUX_OUT ;
    pipeline_mux  #(.WIDTH(18),.ENABLE(DREG),.RST_MODE(RSTTYPE)) D_REG (D,clk,D_MUX_OUT,RSTD,CED);
    // input opmode 
    wire [7:0] OPMODEIN;
    pipeline_mux  #(.WIDTH(8),.ENABLE(OPMODEREG),.RST_MODE(RSTTYPE)) OPMODE_REG (OPMODE,clk,OPMODEIN,RSTOPMODE,CEOPMODE);
    // input carryin
    wire CIN ;
    assign CARRYIN_SEL =(CARRYINSEL == "OPMODE5")  ? OPMODEIN[5] :
                        (CARRYINSEL == "CARRYIN")  ? CARRYIN :
                        0;
    pipeline_mux  #(.WIDTH(1),.ENABLE(CARRYINREG),.RST_MODE(RSTTYPE)) CYI (CARRYIN_SEL,clk,CIN,RSTCARRYIN,CECARRYIN);
    // output carryout 
    pipeline_mux  #(.WIDTH(1),.ENABLE(CARRYOUTREG),.RST_MODE(RSTTYPE)) CYO (Post_Adder_subtractor_carryout,clk,CARRYOUT,RSTCARRYIN,CECARRYIN);
    // M REG  
    wire [35:0] M_MUX_OUT ;
    pipeline_mux  #(.WIDTH(36),.ENABLE(MREG),.RST_MODE(RSTTYPE)) M_REG (MULTIPLICATION_OUT,clk,M_MUX_OUT,RSTC,CEM);
    // P REG 
    pipeline_mux  #(.WIDTH(48),.ENABLE(PREG),.RST_MODE(RSTTYPE)) P_REG (Post_Adder_subtractor_out_reg,clk,P,RSTP,CEP);

    // Pre Adder/Subtractor
    assign Pre_Adder_subtractor_out = (OPMODEIN[6]) ? 
                                   (D_MUX_OUT - B0_MUX_OUT) : 
                                   (D_MUX_OUT + B0_MUX_OUT);

    // OPMODE[4] MUX
    assign opmode4_mux_out = (OPMODEIN[4]) ? 
                          Pre_Adder_subtractor_out : 
                          B0_MUX_OUT;

    // Multiplication Operation
    assign MULTIPLICATION_OUT = A1_MUX_OUT * B1_MUX_OUT;

    // MUX X based on OPMODE[1:0]
    assign X = (OPMODEIN[1:0] == 2'b00) ? 47'b0 :
           (OPMODEIN[1:0] == 2'b01) ? M_MUX_OUT :
           (OPMODEIN[1:0] == 2'b10) ? P :
           {D_MUX_OUT[11:0], A1_MUX_OUT[17:0], B1_MUX_OUT[17:0]}; // 2'b11

    // MUX Z based on OPMODE[3:2]
    assign Z = (OPMODEIN[3:2] == 2'b00) ? 47'b0 :
           (OPMODEIN[3:2] == 2'b01) ? PCIN :
           (OPMODEIN[3:2] == 2'b10) ? P :
           C_MUX_OUT; // 2'b11

    // Post Adder/Subtractor
    wire [48:0] Post_Adder_subtractor_temp = (OPMODEIN[7]) ?
                                         (Z - (X + CIN)) :
                                         (Z + X + CIN);

    assign Post_Adder_subtractor_out = Post_Adder_subtractor_temp;
    assign Post_Adder_subtractor_out_reg = Post_Adder_subtractor_temp[47:0];
    assign Post_Adder_subtractor_carryout = Post_Adder_subtractor_temp[48];

    // Other assignments
    assign BCOUT = B1_MUX_OUT;
    assign M = M_MUX_OUT;
    assign CARRYOUTF = CARRYOUT;
    assign PCOUT = P;

endmodule