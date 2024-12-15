transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/RegisterFile.v}

vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/RegisterFile_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  RegisterFile

add wave *
view structure
view signals
run -all
