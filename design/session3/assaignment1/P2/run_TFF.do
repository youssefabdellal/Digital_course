vlib work
vlog parameterized_FF.v
vlog T_flipflop.v
vlog TFF_tb.v
vsim -voptargs=+acc work.TFF_tb
add wave *
run -all
#quit -sim