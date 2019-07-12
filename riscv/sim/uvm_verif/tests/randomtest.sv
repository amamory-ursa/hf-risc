import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_src/environment.sv"
`include "../uvm_src/memory_model.sv"
`include "../uvm_src/sequence.sv"
`include "../uvm_src/randomtest/random_instruction.sv"
`include "../uvm_src/randomtest/random_program.sv"

`define NUM_PROGRS          10
`define PROG_LENGTH         10
`define INSTRUCTS_TYPE      itype'(RTYPE)       //, ITYPE, UTYPE, STYPE, BTYPE, JTYPE, NULL_TYPE
`define INSTRUCTS_OPCODE    opcode'(NULL_OPCODE)    // ADD, ..., SRA, ..., LB, ..., ANDI, ..., JAL, NULL_OPCODE

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
	  for (i = 0; i < `NUM_PROGRS; i++) begin

            //create a new randomized program
            p = new (`PROG_LENGTH, `INSTRUCTS_TYPE, `INSTRUCTS_OPCODE);
            program_code = p.toString();

            //display on screen
            $display("-------------------------------");
            $display(program_code);

            //save to file
            $sformat(filename, "randomtest/apps/app%0d/app%0d.S", i, i);    // Auxiliary variable for Assembly creation
            $sformat(dirname,  "randomtest/apps/app%0d", i);                // Auxiliary variable for directory creation
            $system({"mkdir ", dirname});                                   // Directory creation
            f = $fopen(filename);                                           // Asssembly file creation
            $fwrite(f, "%s", program_code);                                 // Asssembly creation
            $fclose(f);                                                     // Asssembly file creation
            $system({"cp randomtest/apps/build.sh ", dirname});             // Copy build script into app$d directory
            $system({"(cd ", dirname, " ; bash build.sh)"});                // Build for binary creation
            $system({"cp ", dirname, "/code.txt ./code.txt"});              // Copy binary file into simulaiton directory

        // Connects the sequence to the generator inside the agent
      
	phase.raise_objection(this);
      
	  seq.seqce = env.agt.seqcr;
        seq.start(seq.seqce);
	
      phase.drop_objection(this);
//	  
        //
        end
	
        // $system({"bash apps/cleanup.sh"});

        
    endtask: run_phase

endclass: randomtest
