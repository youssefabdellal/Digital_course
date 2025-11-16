vlib work
vlog *v +cover 
vsim -voptargs=+acc priority_enc_top -cover -sv_seed random -l sim.log
add wave *
coverage save priority_enc.ucdb -onexit -du priority_enc
run -all