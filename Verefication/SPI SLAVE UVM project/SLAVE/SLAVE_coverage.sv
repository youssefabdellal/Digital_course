package SLAVE_coverage_pkg;
    import uvm_pkg::*;
    import SLAVE_item_pkg::*;
    `include "uvm_macros.svh"

    class SLAVE_coverage extends uvm_component;
        `uvm_component_utils(SLAVE_coverage)
        uvm_analysis_export #(SLAVE_item) cov_export;
        uvm_tlm_analysis_fifo #(SLAVE_item) cov_fifo;
        SLAVE_item seq_item_cov;

        covergroup covcode;
            A_cp : coverpoint seq_item_cov.rx_data[9:8] ;

            SS_n: coverpoint seq_item_cov.SS_n {
                bins normal_transaction = (1 => 0 [*12] => 1);
                bins extended_transaction = (1 => 0 [*22] => 1);
                bins communication_on  = {0} ;
            }

            MOSI: coverpoint seq_item_cov.MOSI {
                bins write_address = (0 => 0 => 0);
                bins write_DATA    = (0 => 0 => 1);
                bins read_ADDRESS  = (1 => 1 => 0);
                bins read_DATA     = (1 => 1 => 1);
            }

            cross SS_n , MOSI {
                option.cross_auto_bin_max = 0;
                bins write_add_normal = binsof (MOSI.write_address) && binsof (SS_n.communication_on);
                bins write_data_normal = binsof (MOSI.write_DATA)    && binsof (SS_n.communication_on);
                bins read_add_normal = binsof (MOSI.read_ADDRESS)  && binsof (SS_n.communication_on);
                bins read_data_extended = binsof (MOSI.read_DATA)     && binsof (SS_n.communication_on);
            }
        endgroup

        function new (string name = "SLAVE_coverage" , uvm_component parent = null);
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