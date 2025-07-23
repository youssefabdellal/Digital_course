vlib work
vlog parameterized_FF.v
vlog D_flipflop.v
vlog DFF_tb.v
vsim -voptargs=+acc work.DFF_tb
add wave *
run -all
#quit -sim