package ALSU_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_item_pkg::*;

    class ALSU_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ALSU_scoreboard)
        uvm_analysis_export #(ALSU_item) sb_export;
        uvm_tlm_analysis_fifo #(ALSU_item) sb_fifo;
        ALSU_item seq_item_sb;
        logic signed [5:0] out_ref;
        logic [15:0] leds_ref ;
        bit invalid ;

        ALSU_item ref_pipe[$];
        ALSU_item tmp;

        int error_count   = 0 ;
        int correct_count = 0 ;

        function new (string name = "ALSU_scoreboard" , uvm_component parent = null);
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
            "Simulation Summary ALSU : correct_count=%0d, error_count=%0d",
            correct_count, error_count
            ), UVM_NONE)
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                tmp = ALSU_item::type_id::create("tmp");
                sb_fifo.get(seq_item_sb);
                seq_item_sb.copy(tmp);   
                ref_pipe.push_back(tmp);
                if (ref_pipe.size() >= 2) begin
                    ALSU_item delayed_item;
                    delayed_item = ref_pipe.pop_front();
                    ref_seq_item_chk_model(delayed_item);
                    if (delayed_item.out != out_ref || delayed_item.leds != leds_ref) begin
                        `uvm_error("SCOREBOARD", $sformatf(
                                    "Comparison FAIL: opcode=%0d, A=%0d, B=%0d, got out=%0d leds=%0h, expected out=%0d leds=%0h",
                                        delayed_item.opcode, delayed_item.A, delayed_item.B,
                                        delayed_item.out, delayed_item.leds, out_ref, leds_ref))
                        error_count++;
                    end
                    else correct_count++;
                end
            end
        endtask : run_phase


        task ref_seq_item_chk_model(ALSU_item seq_item_chk);
            leds_ref = 0 ;
            invalid = (seq_item_sb.opcode == 3'b110) || 
                        (seq_item_sb.opcode == 3'b111) || 
                        ((seq_item_sb.red_op_A || seq_item_sb.red_op_B) && 
                        (seq_item_sb.opcode != 3'b000) && (seq_item_sb.opcode != 3'b001)) ;
            if (seq_item_sb.rst) begin
                out_ref  = 0 ;
            end
            else if (seq_item_sb.bypass_A) out_ref = seq_item_sb.A;
            else if (seq_item_sb.bypass_B) out_ref = seq_item_sb.B;
            else if (invalid) out_ref = 0;
            else if (seq_item_sb.opcode == 0) begin
                if (seq_item_sb.red_op_A) out_ref = |seq_item_sb.A ;
                else if (seq_item_sb.red_op_B) out_ref = |seq_item_sb.B ;
                else out_ref = seq_item_sb.A | seq_item_sb.B ;
            end
            else if (seq_item_sb.opcode == 1) begin
                if (seq_item_sb.red_op_A) out_ref = ^seq_item_sb.A ;
                else if (seq_item_sb.red_op_B) out_ref = ^seq_item_sb.B ;
                else out_ref = seq_item_sb.A ^ seq_item_sb.B ;
            end
            else if (seq_item_sb.opcode == 2) out_ref = seq_item_sb.A + seq_item_sb.B + seq_item_sb.cin ;
            else if (seq_item_sb.opcode == 3) out_ref = seq_item_sb.A * seq_item_sb.B ;

            if (seq_item_sb.rst) leds_ref = 0 ;
            begin
                if (invalid)
                leds_ref = ~leds_ref;
            end
        endtask
    endclass 

endpackage