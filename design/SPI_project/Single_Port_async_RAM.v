module RAM(din,clk,rst_n,rx_valid,dout,tx_valid,cs);
    // input & output ports 
    input [9:0] din;
    input clk;
    input rst_n;
    input rx_valid ;
    input [2:0] cs ;
    output reg [7:0] dout;
    output reg tx_valid ;
    // parameters to detect memory size 
    parameter MEM_DEPTH = 256;
    parameter  ADDR_SIZE = 8 ;
    // internal signals 
    reg [7:0] mem [MEM_DEPTH-1:0];
    reg [7:0] memory_address;
    reg address_recieved ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
        dout <= 0 ;
        else begin
            tx_valid <= 0 ;
            if (rx_valid) begin
                // checking reading data or reading address 
                if (din[9] && !din[8])
                address_recieved <= 1 ;
                else if (din[9] && din[8])
                address_recieved <= 0 ;
                // recieving write address 
                if (cs == 3'b010 && din[9:8] == 00) 
                memory_address <= din[7:0];
                // recieving write data
                else if (cs == 3'b010 && din[9:8] == 01)
                mem [memory_address] <= din[7:0]; 
                // recieving read address 
                else if (cs == 3'b011) 
                memory_address <= din[7:0];
                // sending data from memory 
                else if (cs == 3'b100) begin
                    dout <= mem [memory_address]; 
                    tx_valid <= 1 ;
                end
            end
        end
    end
endmodule