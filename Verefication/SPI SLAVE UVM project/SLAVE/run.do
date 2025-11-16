vlib work
vlog +define+SIM +cover *.sv
vsim -voptargs=+acc work.SLAVE_top -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/SLAVE_top/inst_if/*
add wave /SLAVE_top/inst_DUT/assert_idle_to_chk_cmd /
SLAVE_top/inst_DUT/assert_idle_to_idle /SLAVE_top/
inst_DUT/assert_chk_cmd_to_write /SLAVE_top/inst_DUT/
assert_chk_cmd_to_read_add /SLAVE_top/inst_DUT/
assert_chk_cmd_to_read_data /SLAVE_top/inst_DUT/
assert_chk_cmd_to_idle /SLAVE_top/inst_DUT/assert_write_to_idle /SLAVE_top
/inst_DUT/assert_write_to_write /SLAVE_top/inst_DUT/assert_read_add_to_idle
/SLAVE_top/inst_DUT/assert_read_add_to_read_add /SLAVE_top/inst_DUT/
 assert_read_data_to_idle /SLAVE_top/inst_DUT/assert_read_data_to_read_data 
 /SLAVE_top/inst_DUT/assert_valid_states /SLAVE_top/inst_DUT/a_check_reset
coverage save -instance /SLAVE_top/inst_DUT SLAVE.ucdb -onexit
run -all