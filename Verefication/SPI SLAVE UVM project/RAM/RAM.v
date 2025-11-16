module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);

    input  [9:0] din;
    input  clk, rst_n, rx_valid;

    output reg [7:0] dout;
    output reg tx_valid;

    reg [7:0] MEM [255:0];
    reg [7:0] Rd_Addr, Wr_Addr;

    integer i ;
    always @(posedge clk) begin
        if (~rst_n) begin
            dout     <= 0;
            tx_valid <= 0;
            Rd_Addr  <= 0;
            Wr_Addr  <= 0;
        end
        else  begin
            if (rx_valid) begin //add begin/end
                case (din[9:8])
                    2'b00 : Wr_Addr      <= din[7:0];
                    2'b01 : MEM[Wr_Addr] <= din[7:0];
                    2'b10 : Rd_Addr      <= din[7:0];
                    2'b11 : dout         <= MEM[Rd_Addr];//bug fixed   
                    default : dout <= 0;
                endcase
                tx_valid <= (din[9:8] == 2'b11) ? 1'b1 : 1'b0;
            end
        end                                        
    end
endmodule