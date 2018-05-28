set StdArithNoWarnings 0
set NumericStdNoWarnings 0

if {[file isdirectory work]} { vdel -all -lib work }
vlib work

vlog -work work ../hfrv_interface.sv
vlog -work work ../memory.sv
vlog -work work ../generator.sv
vlog -work work test_generator.sv

vsim -novopt work.top

run 10ns


