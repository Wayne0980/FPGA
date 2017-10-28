transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {and_gate_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/Q/Desktop/Wayne/FPGA/2-And_Gate {C:/Users/Q/Desktop/Wayne/FPGA/2-And_Gate/and_gate_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  and_gate_tb

add wave *
view structure
view signals
run 1 us
