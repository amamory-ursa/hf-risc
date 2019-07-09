import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_src/environment.sv"
`include "../uvm_src/memory_model.sv"
`include "../uvm_src/sequence.sv"
`include "../uvm_src/randomtest/random_instruction.sv"
`include "../uvm_src/randomtest/random_program.sv"

`define NUMPROGRS 2

class randomtest extends uvm_test;
    `uvm_component_utils(randomtest)

    environment env;
    memory_sequence seq;
    random_program p;
    string program_code;
    string filename;
    string dirname;
    int f;
    int i;


    /////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////
    function new(string name="randomtest", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    /////////////////////////////////////////////////
    // Configure Phase
    ////////////////////////////////////////////////
    task configure_phase(uvm_phase phase);
        super.configure_phase(phase);
    endtask: configure_phase

    /////////////////////////////////////////////////
    // Build Phase
    ////////////////////////////////////////////////
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        for (i = 0; i < `NUMPROGRS; i++) begin

            //create a new randomized program
            p = new (5); 
            program_code = p.toString();

            //display on screen
            $display("-------------------------------");
            $display(program_code);

            //save to file (note that these files are compiled elsewhere)
            $sformat(filename, "randomtest/apps/app%0d/app%0d.S", i, i);
            $sformat(dirname,  "randomtest/apps/app%0d", i);
            $system({"mkdir ", dirname});
            f = $fopen(filename);
            $fwrite(f, "%s", program_code);
            $fclose(f);
        end
        $system({"bash randomtest/apps/generate_build.sh"});
        // $system({"bash apps/cleanup.sh"});

        // Creates the environment module
        env = environment::type_id::create("env", this);
        
        // Creates the sequencer module
        seq = memory_sequence::type_id::create("seq", this);

    endfunction: build_phase


    /////////////////////////////////////////////////
    // Run Phase
    ////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);

        // Connects the sequence to the generator inside the agent
        seq.seqce = env.agt.seqcr;

        seq.start(seq.seqce);

        phase.drop_objection(this);
        
    endtask: run_phase

endclass: randomtest
