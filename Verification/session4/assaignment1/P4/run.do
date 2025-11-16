vlib work
vlog TESTBENCH.sv Package.sv config_reg_buggy_questa.svp +cover -covercells
vsim -voptargs=+acc work.reg_buggy_tb -cover
add wave *
coverage save config_reg_buggy_questa.ucdb -onexit -du ALSU
run -all