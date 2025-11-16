vlib work
vlog -f src_files.list +cover +covercells +coveropt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
vsim -sv_seed 1906057213 work.top
add wave -r sim:/top/RAM_if/*
coverage save RAM.ucdb -onexit
run -all