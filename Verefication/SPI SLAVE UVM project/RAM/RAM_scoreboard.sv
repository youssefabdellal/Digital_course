package scoreboard_pkg;
    import seq_item_pkg::*; 
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)

        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;

        RAM_seq_item seq_item_sb;

        int error_count = 0;
        int correct_count = 0;

        function new (string name = "RAM_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo   = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if (seq_item_sb.dout !== seq_item_sb.dout_ref || seq_item_sb.tx_valid !== seq_item_sb.tx_valid_ref) begin
                    `uvm_error("run_phase",
                        $sformatf("%s comparison failed, DUT dout=%0b tx_valid=%0b, REF dout=%0b tx_valid=%0b",
                            seq_item_sb.convert2string(), seq_item_sb.dout, seq_item_sb.tx_valid, seq_item_sb.dout_ref, seq_item_sb.tx_valid_ref))
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase",
                        $sformatf("%s correct dout=%0b tx_valid=%0b",
                            seq_item_sb.convert2string(), seq_item_sb.dout, seq_item_sb.tx_valid), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transactions : %0d", correct_count),UVM_MEDIUM)
            `uvm_info("report_phase",$sformatf("Total failed transactions : %0d", error_count),UVM_MEDIUM)
        endfunction
    endclass
endpackage
