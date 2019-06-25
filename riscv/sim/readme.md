
This directory has different verification environments built with different languages and methodologies. Choose the one most appropriated to your case:

- **vhdl**: it is a very simple testbench where it models the memory, which is loaded with the compiled application;
- **sv_simple**: it is pretty much the same testbench above, but translated to SystemVerilog;
- **sv_verif**: it is a more complex testbench divided into several submodules (monitor, drinver, generator, scoreboard, checker, environment, coverage, etc). It has two modes, a simpler one that read an application from a file, and a pseudo-random code generator;
- **uvm_verif**: it is a similar to the previous one, but using UVM methodology. 

sv_verif files:
* randomtest/apps/build:            environment variables setting and app's (e.g. fibonacci, sort, ...) object code generation.
* randomtest/apps/run:              simulation of random test (sim_randomtest.do).
* randomtest/generate.do:           simulates HF-RISCV testbench with random seed parameter.
* randomtest/generate.sh:           calls HF-RISCV testbench simulation (generate.do), build apps and run all apps.
* randomtest/random_gentb.sv:       creates n random programs.
* randomtest/random_instruction.sv: randomly generates RISC V assembly intructions to be executed.
* randomtest/random_program.sv:     adds header and foot for randomly generated RISC V intructions in randomtest/random_instruction.sv to compose a RISC V assembly program.
* randomtest/run_all.sh:            calls random tests generation (generate.sh), runs all tests and runs coverage analysis.

