vlib work
vcom -93 -explicit ../../../core_rv32i/bshifter.vhd
vcom -93 -explicit ../../../core_rv32i/alu.vhd
vcom -93 -explicit ../../../core_rv32i/reg_bank.vhd
vcom -93 -explicit ../../../core_rv32i/uart.vhd
vcom -93 -explicit ../../../core_rv32i/control.vhd
vcom -93 -explicit ../../../core_rv32i/datapath.vhd
vcom -93 -explicit ../../../core_rv32i/peripherals_busmux.vhd
vlog ../../hf_riscv_sim.c
vlog ../../tb_top.sv

vsim work.tb_top

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

coverage save -onexit coverage.ucdb

run -all
