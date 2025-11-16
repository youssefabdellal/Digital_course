package shift_reg_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
        import shift_reg_item_pkg::*;

    class shift_reg_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(shift_reg_scoreboard)
        uvm_analysis_export #(shift_reg_item) sb_export;
        uvm_tlm_analysis_fifo #(shift_reg_item) sb_fifo;
        shift_reg_item seq_item_sb;
        logic [5:0] dataout_ref;

        int error_count =0 ;
        int correct_count =0 ;

        function new (string name = "shift_reg_scoreboard" , uvm_component parent = null);
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
            "Simulation Summary shifter: correct_count=%0d, error_count=%0d",
            correct_count, error_count
            ), UVM_NONE)
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_seq_item_chk_model(seq_item_sb);
                if (seq_item_sb.dataout != dataout_ref) begin
                    `uvm_error("run_phase" , "comaprison fail");
                    error_count++;
                end
                else correct_count++;
            end
        endtask: run_phase

        task ref_seq_item_chk_model(shift_reg_item seq_item_chk);
            if (seq_item_chk.reset)
                dataout_ref <= 0;
            else
                if (seq_item_chk.mode) 
                    if (seq_item_chk.direction) 
                        dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.datain[5]};
                else
                    dataout_ref = {seq_item_chk.datain[0], seq_item_chk.datain[5:1]};
            else 
                if (seq_item_chk.direction) 
                    dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.serial_in};
                else
                    dataout_ref = {seq_item_chk.serial_in, seq_item_chk.datain[5:1]};
        endtask

    endclass 

endpackage