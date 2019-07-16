import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_src/environment.sv"
`include "../uvm_src/memory_model.sv"
`include "../uvm_src/sequence.sv"
`include "../uvm_src/randomtest/random_instruction.sv"
`include "../uvm_src/randomtest/random_program.sv"

`define NUM_PROGRS_RTYPE    2               // Amount of constrained random RTYPE programs to be created and simulated
`define NUM_PROGRS_ITYPE    2               // Amount of constrained random ITYPE programs to be created and simulated
`define NUM_PROGRS_STYPE    1               // Amount of constrained random STYPE programs to be created and simulated
`define NUM_PROGRS_BTYPE    0               // Amount of constrained random BTYPE programs to be created and simulated
`define NUM_PROGRS_UTYPE    0               // Amount of constrained random UTYPE programs to be created and simulated
`define NUM_PROGRS_JTYPE    1               // Amount of constrained random JTYPE programs to be created and simulated
`define PROG_LENGTH         100             // Amount of instructions in each constrained random program
`define ITYPE_MEM_RANGE                     // For memomry write address range control
`define INSTRUCTS_OPCODE    opcode'(NULL_OPCODE)    // ADD,   ...,   SRA, ..., LB, ..., ANDI,  ...,   JAL,   NULL_OPCODE

class randomtest extends uvm_test;
    `uvm_component_utils(randomtest)

    environment env;                //
    memory_sequence seq;            //
    random_program program_rand;    // random assembly program
    string program_code;            // assembly code on string format
    string filename;                //
    string dirname;                 //  program directory 
    int f;                          //  program code file handler
    int i;                          //

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

        phase.raise_objection(this);

        // RTYPE
        for (i = 0; i < `NUM_PROGRS_RTYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(RTYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end

        // ITYPE
        for (i = 0; i < `NUM_PROGRS_ITYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(ITYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end

        // STYPE
        for (i = 0; i < `NUM_PROGRS_STYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(STYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end

        // UTYPE
        for (i = 0; i < `NUM_PROGRS_UTYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(UTYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end

        // BTYPE
        for (i = 0; i < `NUM_PROGRS_BTYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(BTYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end

        // JTYPE
        for (i = 0; i < `NUM_PROGRS_JTYPE; i++) begin

            //create a new randomized program
            program_rand = new (`PROG_LENGTH, itype'(JTYPE), `INSTRUCTS_OPCODE);
            program_code = program_rand.toString();

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
            seq.seqce = env.agt.seqcr;
            seq.start(seq.seqce);
            
        end
        phase.drop_objection(this);
	
        // $system({"bash apps/cleanup.sh"});
        
    endtask: run_phase

endclass: randomtest
