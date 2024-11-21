transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {single_cycle.vo}

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/single_cycle_tb1.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  single_cycle_tb1

add wave *
view structure
view signals
run -all
