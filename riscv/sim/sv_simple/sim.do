set StdArithNoWarnings 0
set NumericStdNoWarnings 0

if {[file isdirectory work]} { vdel -all -lib work }
vlib work

#core
vcom -93 -explicit ../../core_rv32i/bshifter.vhd
vcom -93 -explicit ../../core_rv32i/alu.vhd
vcom -93 -explicit ../../core_rv32i/reg_bank.vhd
vcom -93 -explicit ../../core_rv32i/control.vhd
vcom -93 -explicit ../../core_rv32i/datapath.vhd
vcom -93 -explicit ../../core_rv32i/int_control.vhd
vcom -93 -explicit ../../core_rv32i/cpu.vhd
# peripheral
#vcom -93 -explicit ../../../devices/peripherals/minimal_soc.vhd
vcom -93 -explicit ../../../devices/controllers/uart/uart.vhd
vcom -93 -explicit ../../../devices/peripherals/basic_soc_uart.vhd
vcom -93 -explicit ../vhdl/boot_ram.vhd
vcom -93 -explicit ../vhdl/ram.vhd
# tb
vlog -work work interface_cpu_busmux.sv
vlog -work work interface_busmux_mem.sv
vlog -work work test_hf_riscv.sv
vlog -work work top_hf_riscv.sv
vsim -novopt work.top_hf_riscv

do wave.do

# shut up the annoying warnings
set StdArithNoWarnings 1
set StdNumNoWarnings 1
set NumericStdNoWarnings 1
run 0 ns;
set StdArithNoWarnings 0
set StdNumNoWarnings 0
set NumericStdNoWarnings 0


run -all


