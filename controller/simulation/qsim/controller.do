onerror {quit -f}
vlib work
vlog -work work controller.vo
vlog -work work controller.vt
vsim -novopt -c -t 1ps -L max7000s_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.controller_vlg_vec_tst
vcd file -direction controller.msim.vcd
vcd add -internal controller_vlg_vec_tst/*
vcd add -internal controller_vlg_vec_tst/i1/*
add wave /*
run -all
