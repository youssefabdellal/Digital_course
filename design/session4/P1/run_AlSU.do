vlib work
vlog DFF.v
vlog RTL_DESIGN.v
vlog TESTBENCH.v
vsim -voptargs=+acc work.ALSU_TB
add wave *
run -all
#quit -sim