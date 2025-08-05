module interface (MOSI,MISO,SS_n,clk,rst_n);
    // FSM parameters 
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter WRITE = 3'b010 ;
    parameter READ_ADD = 3'b011 ;
    parameter READ_DATA = 3'b100 ;
    // input & outputs ports 
    input MOSI ;
    input SS_n ;
    input clk ;
    input rst_n;
    output MISO ;
    // internal signals
    wire reading_ADD = 0 ;
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;
    (* fsm_encoding = "one_hot" *)
    reg [2:0] cs , ns ;
    // master and slave modules instantiation
    SPI slave (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    RAM master (rx_data,clk,rst_n,rx_valid,tx_data,tx_valid,cs);
    // state memory 
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) 
        cs <= IDLE ;
        else 
        cs <= ns ;
    end 
    // next state logic
    always @(cs,MOSI,SS_n) begin
        case (cs)
            IDLE : begin
                if (SS_n)
                ns = IDLE ;
                else 
                ns = CHK_CMD ;
            end
            CHK_CMD : begin
                if (SS_n)
                ns = IDLE ;
                else if (!SS_n && !slave.serial_data [10])
                ns = WRITE ;
                else if (!SS_n && slave.serial_data [10] && !master.address_recieved)
                ns = READ_ADD ;
                else if (!SS_n && slave.serial_data [10] && master.address_recieved)
                ns = READ_DATA;
            end
            WRITE : begin
                if (!SS_n && !rx_valid && !tx_valid)
                ns = WRITE ;
                else if (SS_n)
                ns = IDLE ;
            end
            READ_ADD : begin
                if (!SS_n && !rx_valid)
                ns = READ_ADD ;
                else if (SS_n)
                ns = IDLE ;
            end
            READ_DATA : begin
                if (!SS_n && !tx_valid && !slave.output_shifted)
                ns = READ_DATA ;
                else if (SS_n)
                ns = IDLE ;
            end
        endcase
    end
endmodule