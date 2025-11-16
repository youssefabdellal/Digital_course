package wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(wrapper_seq_item)

       // Randomized inputs
        rand logic rst_n;
        rand logic SS_n;
        rand bit [10:0] MOSI_array;
        
        // Non-randomized inputs (driven from MOSI_array or constraints)
        logic MOSI;

        // DUT outputs (monitored)
        bit MISO, MISO_ref;
        bit [2:0] prev_op = 3'b000;

        // State tracking variables
        logic [4:0] count;              // Counter for SS_n timing (0-22)
        logic [3:0] bit_index;          // Track which bit of MOSI_array to send (0-10)
        logic prev_SS_n;                // Previous value of SS_n
        bit [10:0] stored_MOSI_array;   // Store the randomized array
        bit [2:0] prev_cmd;             // store the previous command
        
        function new(string name = "wrapper_seq_item");
            super.new(name);
            prev_SS_n = 1'b1;
            count = 0;
            bit_index = 0;
            stored_MOSI_array = 11'b000_0000_0000;
        endfunction

        function string convert2string(); 
            return $sformatf("%s rst_n=%b, SS_n=%b, MOSI=%b", 
                             super.convert2string(), rst_n, SS_n, MOSI);
        endfunction

        function string convert2string_stimuls(); 
            return $sformatf("rst_n=%b, SS_n=%b, MOSI=%b, MISO=%b, MISO_ref=%b",
                              rst_n, SS_n, MOSI, MISO, MISO_ref);
        endfunction

        // constraint section
        // constraint 1 : reset constraint
        constraint reset_cons {
            rst_n dist {1 := 99, 0 := 1};
        }

        // Constraint 2: SS_n timing based on command type
        // For WRITE (000) and READ_ADD (001): SS_n high every 13 cycles
        // For READ_DATA (110, 111): SS_n high every 23 cycles
        constraint SS_n_timing_c {
            if (MOSI_array[10:8] inside {3'b000, 3'b001 ,3'b110}) {
                // Write or Read Address: 13 cycle period (12 low, 1 high)
                SS_n == (count == 12);
            }
            else if (MOSI_array[10:8] inside { 3'b111}) {
                // Read Data: 23 cycle period (22 low, 1 high)
                SS_n == (count == 22);
            }
            else {
                // Default/initial case
                SS_n == (count == 12);
            }
        }

        constraint addr_change {
            MOSI_array[7:0] dist { [8'h00:8'hFF] := 100 };
        }

        // For a write-only sequence, every Write Address operation shall always be followed by either 
        //Write Address or Write Data operation.
        constraint c_write_only {
            if (prev_cmd == 3'b000) {
                MOSI_array[10:8] == 3'b001;
            }
            else if (prev_cmd == 3'b001) {
                MOSI_array[10:8] == 3'b000 ;
            }
            else {
                MOSI_array[10:8] inside {3'b000 , 3'b001};
            }
        };

        //  For a read-only sequence, only Read Address or Read Data operations are allowed.
        constraint c_read_only {
            if (prev_cmd == 3'b110) {
                MOSI_array[10:8] == 3'b111;
            }
            else if (prev_cmd == 3'b111) {
                MOSI_array[10:8] == 3'b110;
            }
            else {
                MOSI_array[10:8] inside {3'b110 , 3'b111 };
            }
        }; 

        //  For a read-only sequence, only Read Address or Read Data operations are allowed.
        constraint c_read_write {
            if (prev_cmd == 3'b000){
                MOSI_array[10:8] inside {3'b000 , 3'b001};
            }
            else if (prev_cmd == 3'b001) {
                MOSI_array[10:8] dist {3'b000:=40 , 3'b110:=60};
            }
            else if (prev_cmd == 3'b110) {
                MOSI_array[10:8] == 3'b111;
            }
            else if (prev_cmd == 3'b111) {
                MOSI_array[10:8] dist {3'b000:=60 , 3'b110:=40};
            }
            else {
                MOSI_array[10:8] inside {3'b000 , 3'b001 , 3'b110 , 3'b111};
            }
        }; 

        // Post-randomize to handle bit-by-bit MOSI assignment and state updates
        function void post_randomize();
            logic is_falling_edge;
            
            is_falling_edge = (prev_SS_n && !SS_n);

            if (!rst_n) begin
                count        = 0;
                bit_index    = 0;
                prev_SS_n    = 1'b1;
                stored_MOSI_array = 11'b0;
                MOSI_array[10:8]  = 3'b000;
                prev_cmd = 0 ;
                MOSI         = 1'b0;
                `uvm_info("RESET", "Reset occurred: internal state reinitialized", UVM_HIGH)
                return; // Skip normal transaction logic this cycle
            end
            
            // Handle SS_n falling edge - start new transaction
            if (is_falling_edge) begin
                stored_MOSI_array = MOSI_array;
                prev_cmd = MOSI_array[10:8];  // Store previous before updating
                bit_index = 0;
                count = 0;
                MOSI = stored_MOSI_array[10];  // Start with MSB
                
                `uvm_info("WRAPPER_ITEM", $sformatf(
                    "New Transaction: cmd=%b, MOSI_array=%b, count=%0d", 
                    prev_cmd, stored_MOSI_array, count
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
            if (MOSI_array[10:8] inside {3'b000, 3'b001 ,3'b110}) begin
                // 13 cycle period
                if (count >= 12) begin
                    count = 0;
                end
                else count++;
            end
            else if (MOSI_array[10:8] inside { 3'b111}) begin
                // 23 cycle period
                if (count >= 22) begin
                    count = 0;
                end
                else count++;
            end
            else begin
                // Default: 13 cycle period
                if (count >= 12) begin
                    count = 0;
                end
                else count++;
            end     
            // Update prev_SS_n for next cycle
            prev_SS_n = SS_n;
        endfunction
    endclass
endpackage