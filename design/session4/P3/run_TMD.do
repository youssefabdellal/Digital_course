vlib work
vlog RTL.v
vlog TESTBENCH.v
vlog DFF.v
vsim -voptargs=+acc work.TDM_tb
add wave *
run -all
#quit -sim