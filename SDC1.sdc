create_clock -name clk -period 35.9 [get_ports {clk}]
set_input_delay -clock clk 1.0 [all_inputs]
set_output_delay -clock clk 1.0 [all_outputs]
