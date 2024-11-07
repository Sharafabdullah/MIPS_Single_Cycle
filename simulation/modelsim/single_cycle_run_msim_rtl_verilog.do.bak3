transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/Adder.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/single_cycle.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/InstMem.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/ControlUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/mux2X1.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/mux4x1.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/DataMem.v}

vlog -vlog01compat -work work +incdir+C:/Users/shara/Desktop/JoSCD/Development\ Phase/Single_Cycle_Code {C:/Users/shara/Desktop/JoSCD/Development Phase/Single_Cycle_Code/single_cycle_tb1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  single_cycle_tb1.v

add wave *
view structure
view signals
run -all
