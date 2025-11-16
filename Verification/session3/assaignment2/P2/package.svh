package adder_package;
    typedef enum int signed { MAXPOS = 7 , ZERO = 0  , MAXNEG = -8 } values_t;
    class adder_class;
        rand logic signed  [3:0] A_cv ;
        rand logic signed  [3:0] B_cv ;
        rand values_t values;
        bit reset_cv ;
        bit clk_cv ;


        constraint reset_constraint {
            reset_cv dist {0:/97 , 1:/3} ;
        }

        constraint A_values {
            A_cv dist { MAXPOS:/20, ZERO:/20, MAXNEG:/20,
                        [-7:-1]:/20, [1:6]:/20 };
        }

        constraint B_values {
            B_cv dist { MAXPOS:/20, ZERO:/20, MAXNEG:/20,
                        [-7:-1]:/20, [1:6]:/20 };
        }

        covergroup covgrp_A @(posedge clk_cv) ;
            cvp1: coverpoint A_cv {
                bins data_0       = {ZERO} ;
                bins data_max     = {MAXPOS};
                bins data_min     = {MAXNEG};
                bins data_default = default ;
            }
            cvp2: coverpoint A_cv {
                bins data_0max   = (ZERO=>MAXPOS) ;
                bins data_maxmin = (MAXPOS=>MAXNEG);
                bins data_minmax = (MAXNEG=>MAXPOS);
            }
        endgroup

        covergroup covgrp_B @(posedge clk_cv) ;
            cvp1: coverpoint B_cv {
                bins data_0       = {ZERO} ;
                bins data_max     = {MAXPOS};
                bins data_min     = {MAXNEG};
                bins data_default = default ;
            }
            cvp2: coverpoint B_cv {
                bins data_0max   = (ZERO=>MAXPOS) ;
                bins data_maxmin = (MAXPOS=>MAXNEG);
                bins data_minmax = (MAXNEG=>MAXPOS);
            }
        endgroup

        function new();
            covgrp_A = new() ;
            covgrp_B = new() ;
        endfunction

        task sampling ();
            if (!reset_cv) begin
                covgrp_A.sample() ;
                covgrp_B.sample() ;
            end
        endtask

    endclass
endpackage