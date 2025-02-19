analyze -f vhdl -lib WORK ../src/constants.vhd
analyze -f vhdl -lib WORK ../src/ffd.vhd
analyze -f vhdl -lib WORK ../src/register.vhd
analyze -f vhdl -lib WORK ../src/adv_iir.vhd
analyze -f vhdl -lib WORK ../src/top.vhd

set power_preserve_rtl_hier_names true

elaborate filter -arch structural -lib WORK > ./elaborate.txt

#link
create_clock -name MY_CLK -period 25.12 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
compile
report_timing > timing_39MHz.txt
report_area > area_39MHz.txt

ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/filter.sdf
write -f verilog -hierarchy -output ../netlist/filter.v
write_sdc ../netlist/filter.sdc
quit
