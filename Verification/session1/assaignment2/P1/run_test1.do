# Compile the design and both testbenches
vlib work
vlog dff.v  +cover -covercells
vlog dff_t1_tb.svh  +cover -covercells
vlog dff_t2_tb.svh  +cover -covercells

# --- Run simulation for first testbench ---
vsim -voptargs=+acc work.DFF_test1 -cover
add wave *
coverage save DFF_test1.ucdb -onexit
run -all 
quit -sim

# --- Run simulation for second testbench ---
vsim -voptargs=+acc work.DFF_test2 -cover
add wave *
coverage save DFF_test2.ucdb -onexit
run -all 
quit -sim

# --- Merge the two coverage databases ---
vcover merge dff_merged.ucdb DFF_test1.ucdb DFF_test2.ucdb -du dff
vcover report dff_merged.ucdb -details -annotate -all