vlib work
vlog DFF.v
vlog TESTBENCH_DFF.v
vsim -voptargs=+acc work.DFF_TB
add wave *
run -all
#quit -sim