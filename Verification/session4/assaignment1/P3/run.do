vlib work
vlog *v  +cover
vsim -voptargs=+acc counter_top -cover -sv_seed random -l sim.log
add wave *
coverage save counter.ucdb -onexit
run -all