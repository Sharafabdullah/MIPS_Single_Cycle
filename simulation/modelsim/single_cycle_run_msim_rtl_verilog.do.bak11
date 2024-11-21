transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/Adder.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/single_cycle.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/InstMem.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/ControlUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/mux2X1.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/mux4x1.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/DataMem.v}

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/MIPS_Single_Cycle-main {C:/Users/User/Desktop/MIPS_Single_Cycle-main/single_cycle_tb1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  single_cycle_tb1

add wave *
view structure
view signals
run -all
