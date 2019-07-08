import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_src/environment.sv"
`include "../uvm_src/memory_model.sv"
`include "../uvm_src/sequence.sv"

class test_top extends uvm_test;
    `uvm_component_utils(test_top)

    environment env;
    memory_sequence seq;

    /////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////
    function new(string name="test_top", uvm_component parent);
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

        // Connects the sequence to the generator inside the agent
        seq.seqce = env.agt.seqcr;

        seq.start(seq.seqce);



        phase.drop_objection(this);
        
    endtask: run_phase



endclass: test_top
