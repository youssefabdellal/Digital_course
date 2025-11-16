package shift_reg_coverage_pkg;
    import uvm_pkg::*;
    import shift_reg_item_pkg::*;
    `include "uvm_macros.svh"

    class shift_reg_coverage extends uvm_component;
        `uvm_component_utils(shift_reg_coverage)
        uvm_analysis_export #(shift_reg_item) cov_export;
        uvm_tlm_analysis_fifo #(shift_reg_item) cov_fifo;
        shift_reg_item seq_item_cov;

        covergroup covcode;
            cv1: coverpoint seq_item_cov.serial_in;
            cv2: coverpoint seq_item_cov.direction;
            cv3: coverpoint seq_item_cov.mode;
        endgroup

        function new (string name = "shift_reg_coverage" , uvm_component parent = null);
            super.new(name , parent) ;
            covcode = new() ;
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo   = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                covcode.sample();
            end
        endtask
    endclass
endpackage