vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/inst_if/*
coverage save ALSU.ucdb -onexit
run -all