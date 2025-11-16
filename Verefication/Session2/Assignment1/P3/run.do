vlib work
vlog ALSU.v Package.svh TESTBENCH.svh +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage exclude -src ALSU.v -line 112 -code s
coverage save ALSU.ucdb -onexit -du ALSU
run -all