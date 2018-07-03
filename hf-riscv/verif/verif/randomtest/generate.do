vlib work

catch "vlog -work work random_instruction.sv" comperror
catch "vlog -work work random_program.sv" comperror
catch "vlog -work work random_gentb.sv" comperror

if [expr {${comperror} != ""}] then {
    quit -f
}

vsim work.testbench -sv_seed random -novopt

run -all
quit -f 
