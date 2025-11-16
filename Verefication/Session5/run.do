vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all
run -all