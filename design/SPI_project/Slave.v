module SPI (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    input MOSI ;
    input SS_n ;
    input clk ;
    input rst_n;
    input [7:0] tx_data;
    input tx_valid;
    output reg MISO ;
    output reg [9:0] rx_data;
    output reg rx_valid;
    reg [10:0] serial_data;     
    reg [3:0] counter_MOSI ;
    reg [3:0] counter_MISO ;
    reg output_shifted;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            serial_data <= 0;
            rx_data <= 0;
            rx_valid <= 0;
            counter_MOSI <= 0;
            counter_MISO <= 0;
            output_shifted <= 0 ;
            MISO <= 0;
        end
        else begin
            if (SS_n == 0) begin
                rx_valid <= 0 ;
                // converting input from series to parallel
                if (counter_MOSI < 11) begin
                    serial_data [10-counter_MOSI] <= MOSI ;
                    counter_MOSI <= counter_MOSI + 1 ;
                end
                else if (counter_MOSI == 11) begin   // RAM write command
                    rx_data <= serial_data [9:0] ;
                    rx_valid <= 1 ;
                    counter_MOSI <= 0 ; 
                    serial_data <= 0 ;
                end
                // converting output from parallel to series 
                if (tx_valid) 
                output_shifted <= 1 ;
                if (output_shifted && counter_MISO < 8 ) begin
                    MISO <= tx_data [7-counter_MISO] ;
                    counter_MISO = counter_MISO + 1 ;
                end
                else if ( counter_MISO == 8) begin
                    output_shifted <= 0;
                    counter_MISO <= 0 ;
                end                
            end
        end
    end 
endmodule