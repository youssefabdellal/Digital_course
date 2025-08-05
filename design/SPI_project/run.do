vlib work
vlog Single_Port_async_RAM.v
vlog Slave.v
vlog SPI_SLAVE.v
vlog TESTBENCH.v
vsim -voptargs=+acc work.tb
add wave *
add wave -position insertpoint  \
sim:/tb/DUT/rx_data \
sim:/tb/DUT/rx_valid \
sim:/tb/DUT/tx_data \
sim:/tb/DUT/tx_valid \
sim:/tb/DUT/cs \
sim:/tb/DUT/ns
add wave -position insertpoint  \
sim:/tb/DUT/slave/serial_data \
sim:/tb/DUT/slave/counter_MOSI
add wave -position insertpoint  \
sim:/tb/DUT/master/din \
sim:/tb/DUT/master/dout \
sim:/tb/DUT/master/mem \
sim:/tb/DUT/master/memory_address
add wave -position insertpoint  \
sim:/tb/DUT/master/memory_address
run -all

#quit -sim