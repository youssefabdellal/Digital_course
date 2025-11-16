package SLAVE_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SLAVE_item_pkg::*;

    class SLAVE_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SLAVE_scoreboard)
        uvm_analysis_export #(SLAVE_item) sb_export;
        uvm_tlm_analysis_fifo #(SLAVE_item) sb_fifo;
        SLAVE_item seq_item_sb;
        logic [9:0]  rx_data_ref;
        logic rx_valid_ref ;
        bit MISO_ref ;

        localparam IDLE      = 3'b000;
        localparam WRITE     = 3'b001;
        localparam CHK_CMD   = 3'b010;
        localparam READ_ADD  = 3'b011;
        localparam READ_DATA = 3'b100;
        logic [2:0] cs, ns;
        logic received_address ;
        logic [3:0] counter;

        int error_count   = 0 ;
        int correct_count = 0 ;

        function new (string name = "SLAVE_scoreboard" , uvm_component parent = null);
            super.new(name , parent) ;
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo   = new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCOREBOARD", $sformatf(
            "Simulation Summary: correct_count=%0d, error_count=%0d",
            correct_count, error_count
            ), UVM_NONE)
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_seq_item_chk_model(seq_item_sb);
                if (rx_data_ref === seq_item_sb.rx_data && rx_valid_ref === seq_item_sb.rx_valid && seq_item_sb.MISO === MISO_ref) begin
                    correct_count++;
                end
                else begin
                    `uvm_error("SCOREBOARD", $sformatf("Mismatch: DUT_data=%0h REF_data=%0h ||
                                                         DUT_rx_valid=%b REF_rx_valid=%b || 
                                                         DUT_MISO=%b REF_MISO=%b"
                                   , seq_item_sb.rx_data, rx_data_ref , seq_item_sb.rx_valid , 
                                   rx_valid_ref , seq_item_sb.MISO , MISO_ref));
                    error_count++;
                end
            end
        endtask : run_phase


        task ref_seq_item_chk_model(SLAVE_item seq_item_chk);
            if (!seq_item_chk.rst_n) begin
                cs = IDLE ;
                rx_data_ref = 0 ;
                rx_valid_ref = 0 ;
                MISO_ref = 0 ;
                counter = 0 ;
                received_address = 0 ;
            end
            else begin
                case (cs) 
                    IDLE: begin
                        rx_valid_ref = 0 ;
                        if (seq_item_chk.SS_n) ns = IDLE ;
                        else ns = CHK_CMD ;
                    end
                    CHK_CMD : begin
                        if (seq_item_chk.SS_n) ns = IDLE ;
                        else begin
                            if (!seq_item_chk.MOSI) ns = WRITE ;
                            else begin
                                if (received_address) ns = READ_DATA ;
                                else ns = READ_ADD ;
                            end
                        end
                        counter = 10 ;
                    end
                    WRITE : begin
                        if (seq_item_chk.SS_n) ns = IDLE ;
                        else ns = WRITE ;
                        if (counter > 0) begin
                            rx_data_ref [counter-1] = seq_item_chk.MOSI;
                            counter = counter - 1 ;
                        end
                        else rx_valid_ref = 1 ;
                    end
                    READ_ADD : begin
                        if (seq_item_chk.SS_n) ns = IDLE ;
                        else ns = READ_ADD;
                        if (counter > 0) begin
                            rx_data_ref [counter-1] = seq_item_chk.MOSI;
                            counter = counter - 1 ;
                        end
                        else begin
                            rx_valid_ref = 1 ;
                            received_address = 1 ;
                        end
                    end
                    READ_DATA : begin
                        if (seq_item_chk.SS_n) ns = IDLE ;
                        else ns = READ_DATA ;
                        if (seq_item_chk.tx_valid) begin
                            rx_valid_ref = 0 ;
                            if (counter > 0) begin
                                MISO_ref = seq_item_chk.tx_data[counter-1];
                                counter = counter - 1 ;
                            end
                            else received_address = 0 ;
                        end
                        else begin
                            if (counter > 0) begin
                                rx_data_ref [counter-1] = seq_item_chk.MOSI;
                                counter = counter - 1 ;
                            end
                            else begin
                                rx_valid_ref = 1 ;
                                counter = 8 ;
                            end
                        end
                    end
                endcase
                cs = ns;
            end
        endtask
    endclass 

endpackage