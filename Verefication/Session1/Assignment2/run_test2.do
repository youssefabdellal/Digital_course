vlib work
vlog dff.v dff_t2_tb.svh  +cover -covercells
vsim -voptargs=+acc work.DFF_test2 -cover
add wave *
coverage save dff.ucdb -onexit -du dff
run -all
