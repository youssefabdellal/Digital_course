package SLAVE_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SLAVE_item extends uvm_sequence_item;
        `uvm_object_utils(SLAVE_item)
        
        // Randomized inputs
        rand logic rst_n;
        rand logic SS_n;
        rand bit [10:0] MOSI_array;
        
        // Non-randomized inputs (driven from MOSI_array or constraints)
        logic MOSI;
        rand logic tx_valid;
        rand logic [7:0] tx_data;
        
        // DUT outputs (monitored)
        logic [9:0] rx_data;
        logic rx_valid;
        logic MISO;

        // State tracking variables
        logic [4:0] count;              // Counter for SS_n timing (0-22)
        logic [3:0] bit_index;          // Track which bit of MOSI_array to send (0-10)
        logic prev_SS_n;                // Previous value of SS_n
        bit [10:0] stored_MOSI_array;   // Store the randomized array
        bit [2:0] current_cmd;          // Store current command being executed

        function new(string name = "SLAVE_item");
            super.new(name);
            prev_SS_n = 1'b1;
            count = 0;
            bit_index = 0;
            stored_MOSI_array = 11'b000_0000_0000;
            current_cmd = 3'b000;
        endfunction

        function string convert2string(); 
            return $sformatf("%s rst_n=%b, MOSI=%b, SS_n=%b, tx_valid=%b, tx_data=%h, rx_data=%h, rx_valid=%b, MISO=%b", 
                           super.convert2string(),
                           rst_n, MOSI, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
        endfunction

        function string convert2string_stimulus(); 
            return $sformatf("rst_n=%b, MOSI=%b, SS_n=%b, tx_valid=%b, tx_data=%h, cmd=%b, count=%0d, bit_idx=%0d",
                           rst_n, MOSI, SS_n, tx_valid, tx_data, current_cmd, count, bit_index);
        endfunction

        // Constraint 1: Reset signal deasserted most of the time
        constraint reset_c {
            rst_n dist {1 := 99, 0 := 1};
        }

        // Constraint 2: SS_n timing based on command type
        // For WRITE (000) and READ_ADD (001): SS_n high every 13 cycles
        // For READ_DATA (110, 111): SS_n high every 23 cycles
        constraint SS_n_timing_c {
            if (current_cmd inside {3'b000, 3'b001 ,3'b110}) {
                // Write or Read Address: 13 cycle period (12 low, 1 high)
                SS_n == (count == 12);
            }
            else if (current_cmd inside { 3'b111}) {
                // Read Data: 23 cycle period (22 low, 1 high)
                SS_n == (count == 22);
            }
            else {
                // Default/initial case
                SS_n == (count == 12);
            }
        }

        // Constraint 3: MOSI_array randomization
        // Only randomize command bits [10:8] when SS_n transitions from 1 to 0
        // Valid commands: 000 (write), 001 (write), 110 (read addr), 111 (read data)
        constraint MOSI_array_c {
            if (prev_SS_n && !SS_n) {
                // Falling edge of SS_n - randomize with valid commands
                MOSI_array[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
                // Data bits [7:0] can be any value
            }
            else {
                // Not a falling edge - keep stored value
                MOSI_array == stored_MOSI_array;
            }
        }

        // Constraint 4: tx_valid signal
        // High only for READ_DATA command (111)
        constraint tx_valid_c {
            if (current_cmd == 3'b111) {
                tx_valid == 1;
            }
            else {
                tx_valid == 0;
            }
        }

        // Constraint: tx_data can be any value
        // constraint tx_data_c {
        //     tx_data inside {[8'h00:8'hFF]};
        // }

        // Post-randomize to handle bit-by-bit MOSI assignment and state updates
        function void post_randomize();
            logic is_falling_edge;
            
            is_falling_edge = (prev_SS_n && !SS_n);
            
            // Handle SS_n falling edge - start new transaction
            if (is_falling_edge) begin
                stored_MOSI_array = MOSI_array;
                current_cmd = MOSI_array[10:8];
                bit_index = 0;
                count = 0;
                MOSI = stored_MOSI_array[10];  // Start with MSB
                
                `uvm_info("SLAVE_ITEM", $sformatf(
                    "New Transaction: cmd=%b, MOSI_array=%b, count=%0d", 
                    current_cmd, stored_MOSI_array, count
                ), UVM_HIGH)
            end
            // Handle SS_n active (low) - continue shifting bits
            else if (!SS_n) begin
                if (bit_index < 11) begin
                    MOSI = stored_MOSI_array[10 - bit_index];
                    bit_index++;
                end
                else begin
                    MOSI = 1'b0;  // Default after all bits sent
                end
            end
            // Handle SS_n inactive (high) - idle
            else begin
                MOSI = 1'b0;
                bit_index = 0;
            end
            
            // Update counter for SS_n timing
            if (current_cmd inside {3'b000, 3'b001 ,3'b110}) begin
                // 13 cycle period
                if (count >= 12) count = 0;
                else count++;
            end
            else if (current_cmd inside { 3'b111}) begin
                // 23 cycle period
                if (count >= 22) count = 0;
                else count++;
            end
            else begin
                // Default: 13 cycle period
                if (count >= 12) count = 0;
                else count++;
            end
            
            // Update prev_SS_n for next cycle
            prev_SS_n = SS_n;
        endfunction

    endclass
endpackage