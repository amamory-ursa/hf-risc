set StdArithNoWarnings 0
set NumericStdNoWarnings 0

if {[file isdirectory work]} { vdel -all -lib work }
vlib work

vlog -work work ../tb_top.sv

#vsim -novopt tp_top.top

#run 10ns


