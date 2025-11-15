vlib work
vlog DSP.v DSP_tb_adding.svh  +cover -covercells
vsim -voptargs=+acc work.DSP_tb_adding -cover
add wave *
coverage save DSP_adding.ucdb -onexit -du DSP
run -all