vlib work
########vlog hf_riscv_sim.c
vcom -93 -explicit ../../../../devices/peripherals/minimal_soc.vhd
vcom -93 -explicit ../../../core_rv32i/bshifter.vhd
vcom -93 -explicit ../../../core_rv32i/alu.vhd
vcom -93 -explicit ../../../core_rv32i/reg_bank.vhd
vcom -93 -explicit ../../../../devices/controllers/uart/uart.vhd
vcom -93 -explicit ../../../core_rv32i/control.vhd
vcom -93 -explicit ../../../core_rv32i/datapath.vhd
vcom -93 -explicit ../../../core_rv32i/int_control.vhd
vcom -93 -explicit ../../../core_rv32i/cpu.vhd
vcom -93 -explicit ../../vhdl/boot_ram.vhd
vcom -93 -explicit ../../vhdl/ram.vhd
vlog ../uvm_src/top_uvm.sv

vsim work.top_uvm -coverage +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_top -novopt
#set NoQuitOnFinish 1
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

add wave -position insertpoint  sim:/top_uvm/clk
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/clock
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/pc
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/inst_in_s
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/branch
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/jump_taken
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/branch_taken
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/bds
add wave -position insertpoint  sim:/top_uvm/riscv/cpu/core/mwait

#run 5000ns
#run 10000ns
#run 150000ns
run 1 ms 
coverage attribute -name TESTNAME -value test_top
coverage save test_top.ucdb
#vcover report test_top.ucdb -cvg -details
