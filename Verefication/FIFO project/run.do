vlib work
vlog +define+SIM +cover *.sv
vsim -voptargs=+acc FIFO_top -cover -sv_seed random -l sim.log
add wave -position insertpoint sim:/FIFO_top/inst_DUT/mem
coverage save FIFO.ucdb -onexit
run -all