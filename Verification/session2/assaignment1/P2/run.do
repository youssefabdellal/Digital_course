vlib work
vlog counter.v package.svh TESTBENCH.svh +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter.ucdb -onexit -du counter
run -all