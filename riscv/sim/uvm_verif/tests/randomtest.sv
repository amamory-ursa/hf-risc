import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_src/environment.sv"
`include "../uvm_src/memory_model.sv"
`include "../uvm_src/sequence.sv"
`include "../uvm_src/randomtest/random_instruction.sv"
`include "../uvm_src/randomtest/random_program.sv"

`define NUMPROGRS   10
`define PROGLENGTH  100

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

        // while coverage_current_value < coverage_acceptance
            // p = new(prog_lentgh, coverage_next_priority_instr)
        // end while
        for (i = 0; i < `NUMPROGRS; i++) begin

            //create a new randomized program
            p = new (`PROGLENGTH, itype'(ITYPE), opcode'(ADD)); 
            program_code = p.toString();

            //display on screen
            $display("-------------------------------");
            $display(program_code);

            //save to file
            $sformat(filename, "randomtest/apps/app%0d/app%0d.S", i, i);    // Auxiliary variable for assembly creation
            $sformat(dirname,  "randomtest/apps/app%0d", i);                // Auxiliary variable for directory creation
            $system({"mkdir ", dirname});                                   // Directory creation
            f = $fopen(filename);                                           // Asssembly file creation
            $fwrite(f, "%s", program_code);                                 // Asssembly creation
            $fclose(f);                                                     // Asssembly file creation
            $system({"cp randomtest/apps/build.sh ", dirname});             // Copy build script into app$d directory
            $system({"(cd ", dirname, " ; bash build.sh)"});                // Build for binary creation
            $system({"cp ", dirname, "/code.txt ./code.txt"});              // Copy binary file to simulaiton directory

        end
        // $system({"bash apps/cleanup.sh"});

        phase.raise_objection(this);
        // Connects the sequence to the generator inside the agent
        seq.seqce = env.agt.seqcr;
        seq.start(seq.seqce);
        phase.drop_objection(this);
        
    endtask: run_phase

endclass: randomtest