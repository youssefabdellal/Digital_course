module golden_model_SLAVE (
    MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid
);

localparam S_IDLE     = 3'b000;
localparam S_WRITE    = 3'b001;
localparam S_CMDCHK   = 3'b010;
localparam S_RDADDR   = 3'b011;
localparam S_RDDATA   = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid;
output bit       MISO;

// renamed internal signals
reg [3:0] bit_counter;
reg       addr_received;

reg [2:0] state_curr, state_next;

// State register
always @(posedge clk) begin
    if (~rst_n)
        state_curr <= S_IDLE;
    else
        state_curr <= state_next;
end

// Next state logic
always @(*) begin
    case (state_curr)
        S_IDLE: begin
            if (SS_n)
                state_next = S_IDLE;
            else
                state_next = S_CMDCHK;
        end

        S_CMDCHK: begin
            if (SS_n)
                state_next = S_IDLE;
            else begin
                if (~MOSI)
                    state_next = S_WRITE;
                else begin
                    if (addr_received)
                        state_next = S_RDDATA;
                    else
                        state_next = S_RDADDR;
                end
            end
        end

        S_WRITE: begin
            if (SS_n)
                state_next = S_IDLE;
            else
                state_next = S_WRITE;
        end

        S_RDADDR: begin
            if (SS_n)
                state_next = S_IDLE;
            else
                state_next = S_RDADDR;
        end

        S_RDDATA: begin
            if (SS_n)
                state_next = S_IDLE;
            else
                state_next = S_RDDATA;
        end
    endcase
end

// Output and data handling
always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data       <= 0;
        rx_valid      <= 0;
        addr_received <= 0;
        MISO          <= 0;
        bit_counter   <= 0;
    end
    else begin
        case (state_curr)
            S_IDLE: begin
                rx_valid <= 0;
            end

            S_CMDCHK: begin
                bit_counter <= 10;
            end

            S_WRITE: begin
                if (bit_counter > 0) begin
                    rx_data[bit_counter-1] <= MOSI;
                    bit_counter <= bit_counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end

            S_RDADDR: begin
                if (bit_counter > 0) begin
                    rx_data[bit_counter-1] <= MOSI;
                    bit_counter <= bit_counter - 1;
                end
                else begin
                    rx_valid      <= 1;
                    addr_received <= 1;
                end
            end

            S_RDDATA: begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (bit_counter > 0) begin
                        MISO <= tx_data[bit_counter-1];
                        bit_counter <= bit_counter - 1;
                    end
                    else begin
                        addr_received <= 0;
                    end
                end
                else begin
                    if (bit_counter > 0) begin
                        rx_data[bit_counter-1] <= MOSI;
                        bit_counter <= bit_counter - 1;
                        rx_valid <= 0;
                    end
                    else begin
                        rx_valid <= 1;
                        bit_counter <= 9;
                    end
                end
            end
        endcase
    end
end

endmodule

module golden_model_RAM (din,clk,rst_n,rx_valid,dout,tx_valid);
    
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    input  [9:0] din;
    input  clk, rst_n, rx_valid;

    output reg [7:0] dout;
    output reg tx_valid;

    reg [ADDR_SIZE-1 : 0] addr_rd, addr_wr; 
    reg [7:0] mem [MEM_DEPTH-1 : 0];

    integer i;
    always @(posedge clk ) begin
        if (!rst_n) begin
            dout     <= 0 ;
            tx_valid <= 0 ;
            addr_rd  <= 0 ;
            addr_wr  <= 0 ;
        end
        else begin
            if (rx_valid) begin
                case (din[9:8])
                    2'b00 : begin
                        addr_wr       <= din[7:0] ;
                        tx_valid  <= 1'b0 ;
                    end
                    2'b01 : begin
                        mem[addr_wr]  <= din[7:0] ;
                        tx_valid <= 1'b0 ;
                    end 
                    2'b10 : begin
                        addr_rd      <= din[7:0] ;
                        tx_valid <= 1'b0 ;
                    end 
                    2'b11 : begin
                        dout     <= mem[addr_rd] ;
                        tx_valid <= 1'b1 ;
                    end 
                    default: dout <= 0;
                endcase
            end
        end
    end
endmodule


module golden_model_SPI_wrapper (
    input  logic MOSI_ref,
    output  logic MISO_ref,
    input  logic SS_n_ref,
    input  logic clk,
    input logic rst_n_ref
);

    // Internal signals connecting RAM and SLAVE
    logic [9:0] rx_data_din_ref;
    logic       rx_valid_ref;
    logic [7:0] tx_data_dout_ref;
    logic       tx_valid_ref;

    // Instantiate the golden model RAM and SLAVE (with identical logic)
    golden_model_RAM RAM_ref (
        .din(rx_data_din_ref),
        .clk(clk),
        .rst_n(rst_n_ref),
        .rx_valid(rx_valid_ref),
        .dout(tx_data_dout_ref),
        .tx_valid(tx_valid_ref)
    );

    golden_model_SLAVE SLAVE_ref (
        .MOSI(MOSI_ref),
        .MISO(MISO_ref),
        .SS_n(SS_n_ref),
        .clk(clk),
        .rst_n(rst_n_ref),
        .rx_data(rx_data_din_ref),
        .rx_valid(rx_valid_ref),
        .tx_data(tx_data_dout_ref),
        .tx_valid(tx_valid_ref)
);

endmodule