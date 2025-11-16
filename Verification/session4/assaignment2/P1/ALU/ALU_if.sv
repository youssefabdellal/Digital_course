interface ALU_if(input bit clk);
    import ALU_package::*;
    logic reset;
    opcode_t opcode;	// The opcode
    logic signed [3:0] A;	// Input data A in 2's complement
    logic signed [3:0] B;	// Input data B in 2's complement
    logic signed [4:0] C ;

    modport DUT (
    input clk , reset , A ,B , opcode ,
    output C 
    );

    modport TEST (
    input C ,
    output clk , reset , A ,B , opcode 
    );
endinterface