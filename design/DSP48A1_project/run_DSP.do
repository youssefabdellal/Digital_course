vlib work
vlog RTL_FILE.v
vlog TESTBENCH.v
vlog PIPELINE_MUX.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim