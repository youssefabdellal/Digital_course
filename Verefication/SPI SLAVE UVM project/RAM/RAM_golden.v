module RAM_golden (din,clk,rst_n,rx_valid,dout_ref,tx_valid_ref);
    
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    input  [9:0] din;
    input  clk, rst_n, rx_valid;

    output reg [7:0] dout_ref;
    output reg tx_valid_ref;

    reg [ADDR_SIZE-1 : 0] addr_rd, addr_wr; 
    reg [7:0] mem [MEM_DEPTH-1 : 0];

    integer i;
    always @(posedge clk ) begin
        if (!rst_n) begin
            dout_ref     <= 0 ;
            tx_valid_ref <= 0 ;
            addr_rd  <= 0 ;
            addr_wr  <= 0 ;
        end
        else begin
            if (rx_valid) begin
                case (din[9:8])
                    2'b00 : begin
                        addr_wr       <= din[7:0] ;
                        tx_valid_ref  <= 1'b0 ;
                    end 
                    2'b01 : begin
                        mem[addr_wr]  <= din[7:0] ;
                        tx_valid_ref  <= 1'b0 ;
                    end 
                    2'b10 : begin
                        addr_rd      <= din[7:0] ;
                        tx_valid_ref <= 1'b0 ;
                    end 
                    2'b11 : begin
                        dout_ref     <= mem[addr_rd] ;
                        tx_valid_ref <= 1'b1 ;
                    end 
                    default: dout_ref <= 0;
                endcase
            end
        end
    end
endmodule