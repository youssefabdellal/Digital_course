vlib work
vlog adder.v adder_tb.sv package.svh  +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder.ucdb -onexit -du adder
run -all