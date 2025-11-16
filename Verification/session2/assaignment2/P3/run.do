vlib work
vlog FSm_010.v test.v TESTBENCH.svh package.svh  +cover -covercells
vsim -voptargs=+acc work.FSM_tb -cover
add wave *
coverage exclude -src FSm_010.v -line 42 -code s
coverage save FSM_010.ucdb -onexit -du FSM_010
run -all