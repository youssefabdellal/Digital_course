vlib work
vlog alu.svh package.svh module.svh +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save alu_seq.ucdb -onexit -du alu_seq
run -all