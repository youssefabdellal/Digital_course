package wrapper_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
        import wrapper_seq_item_pkg::*;

    class wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(wrapper_scoreboard)
        uvm_analysis_export #(wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(wrapper_seq_item) sb_fifo;
        wrapper_seq_item seq_item_sb;

        int error_count = 0;
        int correct_count = 0;

        logic MISO_ref;

        function new (string name = "wrapper_scoreboard" , uvm_component parent = null);
            super.new(name , parent) ;
        endfunction

       function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCOREBOARD", $sformatf("Simulation Summary: 
                correct_count=%0d, error_count=%0d",correct_count, error_count), UVM_NONE)
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

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if (seq_item_sb.MISO != seq_item_sb.MISO_ref) begin
                    `uvm_error("run_phase" , "comaprison fail");
                    error_count++;
                end
                else correct_count++;
            end
        endtask
    endclass 

endpackage