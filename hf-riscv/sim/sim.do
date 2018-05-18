set StdArithNoWarnings 0
set NumericStdNoWarnings 0

if {[file isdirectory work]} { vdel -all -lib work }
vlib work

vcom -93 -explicit ../core_rv32i/bshifter.vhd
vcom -93 -explicit ../core_rv32i/alu.vhd
vcom -93 -explicit ../core_rv32i/reg_bank.vhd
vcom -93 -explicit ../core_rv32i/uart.vhd
vcom -93 -explicit ../core_rv32i/control.vhd
vcom -93 -explicit ../core_rv32i/datapath.vhd
vcom -93 -explicit ../core_rv32i/peripherals_busmux.vhd
vcom -93 -explicit boot_ram.vhd
vcom -93 -explicit ram.vhd
vcom -93 -explicit hf-riscv_tb.vhd
vsim -novopt work.tb

#do wave.do

run -all


