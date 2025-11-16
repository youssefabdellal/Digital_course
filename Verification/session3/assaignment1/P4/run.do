vlib work
vlog DESIGN.svh TESTBENCH.svh +cover -covercells
vsim -voptargs=+acc work.memory_tb -cover
add wave -position insertpoint  \
sim:/memory_tb/TESTS \
sim:/memory_tb/clk_tb \
sim:/memory_tb/write_tb \
sim:/memory_tb/read_tb \
sim:/memory_tb/DATA_in_tb \
sim:/memory_tb/address_tb \
sim:/memory_tb/DATA_out_tb \
sim:/memory_tb/read_data_stored \
sim:/memory_tb/expected_data_out \
sim:/memory_tb/correct_count \
sim:/memory_tb/error_count
coverage save my_mem.ucdb -onexit -du ALSU
run -all