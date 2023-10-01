# operating conditions and boundary conditions #
current_design top
set cycle  9.3        ;#clock period defined by designer

create_clock -period $cycle [get_ports  clk]
set_dont_touch_network      [get_clocks clk]
set_fix_hold  [get_clocks clk]
set_clock_uncertainty  0.1  [get_clocks clk]
set_clock_latency      0.5  [get_clocks clk]
set_ideal_network           [get_ports clk]

set_input_delay  4.65      -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 0.5    -clock clk [all_outputs] 
set_load         0.1     [all_outputs]
set_drive        1     [all_inputs]

set_operating_conditions -min_library saed14rvt_ff0p88vm40c -min ff0p88vm40c  -max_library saed14rvt_ss0p72v125c -max ss0p72v125c
set_wire_load_model -name ForQA -library saed14rvt_ss0p72v125c                        

set_max_fanout 1000 [all_inputs]
