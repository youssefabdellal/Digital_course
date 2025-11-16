vlib work
vlog ALU.v ALU_tb.svh  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_4_bit.ucdb -onexit -du ALU_4_bit
run -all