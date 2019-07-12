For verificaiton there are different verification environments built with different languages and methodologies. Choose the one most appropriated to your case:

- **vhdl**: it is a very simple testbench where it models the memory, which is loaded with the compiled application;
- **sv_simple**: it is pretty much the same testbench above, but translated to SystemVerilog;
- **sv_verif**: it is a more complex testbench divided into several submodules (monitor, driver, generator, scoreboard, checker, environment, coverage, etc). It has two modes, a simpler one that read an application from a file, and a pseudo-random code generator;
- **uvm_verif**: it is a similar to the previous one, but using UVM methodology. Using uvm_verif it is possible to evaluate the simulation of standard applications such as fibonacci and sort, and constrained random generated application.