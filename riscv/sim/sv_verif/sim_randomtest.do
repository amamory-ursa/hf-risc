vlib work
vlog ../hf_riscv_sim.c
vcom -93 -explicit ../../../../devices/peripherals/minimal_soc.vhd
vcom -93 -explicit ../../../core_rv32i/bshifter.vhd
vcom -93 -explicit ../../../core_rv32i/alu.vhd
vcom -93 -explicit ../../../core_rv32i/reg_bank.vhd
#vcom -93 -explicit ../../../core_rv32i/uart.vhd
vcom -93 -explicit ../../../core_rv32i/control.vhd
vcom -93 -explicit ../../../core_rv32i/datapath.vhd
#vcom -93 -explicit ../../../core_rv32i/peripherals_busmux.vhd
vcom -93 -explicit ../../../core_rv32i/int_control.vhd
vcom -93 -explicit ../../../core_rv32i/cpu.vhd
vcom -93 -explicit ../../vhdl/boot_ram.vhd
vcom -93 -explicit ../../vhdl/ram.vhd
vlog ../tb_top.sv

vsim -novopt work.tb_top

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

coverage save -onexit coverage.ucdb

run -all
