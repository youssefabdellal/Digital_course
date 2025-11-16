package seq_item_pkg ;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)
        
        parameter MEM_DEPTH = 256;
        parameter ADDR_SIZE = 8;
        
        //input signals
        rand bit  rst_n;
        rand bit  rx_valid;
        rand bit  [9 : 0] din;
        //output signals
        logic tx_valid ;
        logic tx_valid_ref ;
        logic [7 : 0] dout;
        logic [7 : 0] dout_ref;

        bit [1:0] prev_op = 2'b00;
        // 1 for the read data operation and 0 for the read address operation
        
        function new (string name = "RAM_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst_n = 0b%0b, rx_valid = 0b%0b, din = 0b%0b, tx_valid = 0b%0b, dout = 0b%0b",
                super.convert2string(), rst_n, rx_valid, din, tx_valid, dout);
        endfunction 
        
        function string convert2string_stimulus();
            return $sformatf("%s rst_n = 0b%0b, rx_valid = 0b%0b, din = 0b%0b",
                super.convert2string(), rst_n, rx_valid, din);
        endfunction 

        function void post_randomize();
            prev_op = din[9:8];
        endfunction
        //-----------------constraints---------------

        // The reset signal (rst_n) shall be deasserted most of the time.
        constraint c_rst {rst_n dist {1 := 99 , 0 := 1};};

        //The rx_valid signal shall be asserted most of time.
        constraint c_rx {rx_valid dist {1 := 98 , 0 := 2};};

        // For a write-only sequence, every Write Address operation shall always be followed by either 
        //Write Address or Write Data operation.
        constraint c_write_only { din[9:8] inside {2'b00, 2'b01};};

        //  For a read-only sequence, only Read Address or Read Data operations are allowed.
        constraint c_read_only
        {
            if (prev_op == 2'b10)          // Read address => Read data 
            {         
                din[9:8] == 2'b11;
            }
            else if (prev_op == 2'b11)     // Read data (2'b11) => Read address 
            {     
                din[9:8] == 2'b10;
            }
            else
            {
                din[9:8] inside {2'b11, 2'b10};
            }
        };
        
        //  For a read-write sequence
        constraint c_read_write 
        {
            if (prev_op == 2'b00)                             //After Write Address operation
            { 
                din[9:8] inside { 2'b00, 2'b01};
            }
            else if (prev_op == 2'b01)                        //After Write Data operation
            {
                din[9:8] dist { 2'b00 := 40, 2'b10 := 60};
            }    
            else if (prev_op == 2'b10)                        //After Read Address operation      
            {
                din[9:8] inside { 2'b10, 2'b11};
            }    
            else                                              //After Read Data operation
            {
                din[9:8] dist {  2'b00 := 60, 2'b10 := 40};
            }
        }; 
    endclass
endpackage