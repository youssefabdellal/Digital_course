vlib work
vlog *v +cover 
vsim -voptargs=+acc ALU_top -cover -sv_seed random -l sim.log
add wave *
coverage save ALU_4_bit.ucdb -onexit -du ALU_4_bit
run -all