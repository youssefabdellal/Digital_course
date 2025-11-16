module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid;
output bit       MISO;

reg [3:0] counter;
reg       received_address;
reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        counter <= 0;
        MISO <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end

`ifdef SIM 
    // property check reset
    property check_reset;
        @(posedge clk)
            (!rst_n) |=> (rx_valid == 0 && rx_data == 0 && MISO == 0);
    endproperty

    // Property: IDLE → CHK_CMD transition
    property idle_to_chk_cmd;
        @(posedge clk) disable iff (!rst_n)
        (cs == IDLE && !SS_n) |=> (cs == CHK_CMD);
    endproperty

    // Property: IDLE → IDLE when SS_n is high
    property idle_to_idle;
        @(posedge clk) disable iff (!rst_n)
        (cs == IDLE && SS_n) |=> (cs == IDLE);
    endproperty

    // Property: CHK_CMD → WRITE (when MOSI=0 and SS_n=0)
    property chk_cmd_to_write;
        @(posedge clk) disable iff (!rst_n)
        (cs == CHK_CMD && !SS_n && !MOSI) |=> (cs == WRITE);
    endproperty

    // Property: CHK_CMD → READ_ADD (when MOSI=1, received_address=0, SS_n=0)
    property chk_cmd_to_read_add;
        @(posedge clk) disable iff (!rst_n)
        (cs == CHK_CMD && !SS_n && MOSI && !received_address) |=> (cs == READ_ADD);
    endproperty

    // Property: CHK_CMD → READ_DATA (when MOSI=1, received_address=1, SS_n=0)
    property chk_cmd_to_read_data;
        @(posedge clk) disable iff (!rst_n)
        (cs == CHK_CMD && !SS_n && MOSI && received_address) |=> (cs == READ_DATA);
    endproperty

    // Property: CHK_CMD → IDLE (when SS_n goes high)
    property chk_cmd_to_idle;
        @(posedge clk) disable iff (!rst_n)
        (cs == CHK_CMD && SS_n) |=> (cs == IDLE);
    endproperty

    // Property: WRITE → IDLE (when SS_n goes high)
    property write_to_idle;
        @(posedge clk) disable iff (!rst_n)
        (cs == WRITE && SS_n) |=> (cs == IDLE);
    endproperty

    // Property: WRITE → WRITE (when SS_n remains low)
    property write_to_write;
        @(posedge clk) disable iff (!rst_n)
        (cs == WRITE && !SS_n) |=> (cs == WRITE);
    endproperty

    // Property: READ_ADD → IDLE (when SS_n goes high)
    property read_add_to_idle;
        @(posedge clk) disable iff (!rst_n)
        (cs == READ_ADD && SS_n) |=> (cs == IDLE);
    endproperty

    // Property: READ_ADD → READ_ADD (when SS_n remains low)
    property read_add_to_read_add;
        @(posedge clk) disable iff (!rst_n)
        (cs == READ_ADD && !SS_n) |=> (cs == READ_ADD);
    endproperty

    // Property: READ_DATA → IDLE (when SS_n goes high)
    property read_data_to_idle;
        @(posedge clk) disable iff (!rst_n)
        (cs == READ_DATA && SS_n) |=> (cs == IDLE);
    endproperty

    // Property: READ_DATA → READ_DATA (when SS_n remains low)
    property read_data_to_read_data;
        @(posedge clk) disable iff (!rst_n)
        (cs == READ_DATA && !SS_n) |=> (cs == READ_DATA);
    endproperty

    // Property: Valid states only
    property valid_states_only;
        @(posedge clk) disable iff (!rst_n)
        cs inside {IDLE, WRITE, CHK_CMD, READ_ADD, READ_DATA};
    endproperty

    //========================================================================
    // Assertions
    //========================================================================
    assert_idle_to_chk_cmd: assert property (idle_to_chk_cmd)
        else $error("FSM Error @ %0t: IDLE did not transition to CHK_CMD when SS_n=0", $time);

    assert_idle_to_idle: assert property (idle_to_idle)
        else $error("FSM Error @ %0t: IDLE did not stay in IDLE when SS_n=1", $time);

    assert_chk_cmd_to_write: assert property (chk_cmd_to_write)
        else $error("FSM Error @ %0t: CHK_CMD did not transition to WRITE when MOSI=0", $time);

    assert_chk_cmd_to_read_add: assert property (chk_cmd_to_read_add)
        else $error("FSM Error @ %0t: CHK_CMD did not transition to READ_ADD", $time);

    assert_chk_cmd_to_read_data: assert property (chk_cmd_to_read_data)
        else $error("FSM Error @ %0t: CHK_CMD did not transition to READ_DATA", $time);

    assert_chk_cmd_to_idle: assert property (chk_cmd_to_idle)
        else $error("FSM Error @ %0t: CHK_CMD did not transition to IDLE when SS_n=1", $time);

    assert_write_to_idle: assert property (write_to_idle)
        else $error("FSM Error @ %0t: WRITE did not transition to IDLE when SS_n=1", $time);

    assert_write_to_write: assert property (write_to_write)
        else $error("FSM Error @ %0t: WRITE did not stay in WRITE when SS_n=0", $time);

    assert_read_add_to_idle: assert property (read_add_to_idle)
        else $error("FSM Error @ %0t: READ_ADD did not transition to IDLE when SS_n=1", $time);

    assert_read_add_to_read_add: assert property (read_add_to_read_add)
        else $error("FSM Error @ %0t: READ_ADD did not stay in READ_ADD when SS_n=0", $time);

    assert_read_data_to_idle: assert property (read_data_to_idle)
        else $error("FSM Error @ %0t: READ_DATA did not transition to IDLE when SS_n=1", $time);

    assert_read_data_to_read_data: assert property (read_data_to_read_data)
        else $error("FSM Error @ %0t: READ_DATA did not stay in READ_DATA when SS_n=0", $time);

    assert_valid_states: assert property (valid_states_only)
        else $error("FSM Error @ %0t: Invalid state detected: cs=%b", $time, cs);

    a_check_reset: assert property (check_reset)
        else $error("Assertion FAILED: Reset condition not satisfied — outputs not cleared properly.");

    //========================================================================
    // Coverage for FSM transitions
    //========================================================================
    cover_idle_to_chk_cmd: cover property (idle_to_chk_cmd);
    cover_chk_cmd_to_write: cover property (chk_cmd_to_write);
    cover_chk_cmd_to_read_add: cover property (chk_cmd_to_read_add);
    cover_chk_cmd_to_read_data: cover property (chk_cmd_to_read_data);
    cover_write_to_idle: cover property (write_to_idle);
    cover_read_add_to_idle: cover property (read_add_to_idle);
    cover_read_data_to_idle: cover property (read_data_to_idle);
    c_check_reset: cover property (check_reset);

`endif

endmodule