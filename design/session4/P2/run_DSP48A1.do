vlib work
vlog DFF_18bits.v
vlog DFF_48bits.v
vlog RTL.v
vlog TESTBENCH.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim