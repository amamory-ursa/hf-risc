`ifndef ENVIRONMENT_UVM
 `define ENVIRONMENT_UVM

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "agent.sv"
`include "hfrv_interface.sv"

class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  //Environment components
  agent agt;
  //scoreboard scb;
  //checker ckr;


  /////////////////////////////////////////////////
  // Constructor
  ////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  

  /////////////////////////////////////////////////
  // Build phase
  ////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

      // Creates the Agent
      agt = agent::type_id::create("agent", this);

      // Creates the Scoreboard


      // Creates the Checker


  endfunction : build_phase


  /////////////////////////////////////////////////
  // Configure phase
  ////////////////////////////////////////////////
  /*function void configure_phase(uvm_phase phase);
    super.configure_phase(phase);
  endfunction : configure_phase*/


  /////////////////////////////////////////////////
  // Connect phase
  ////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
    // Connects the agent to the Scoreboard and Checker
  endfunction : connect_phase

  /////////////////////////////////////////////////
  // Run phase
  ////////////////////////////////////////////////
  /*task run_phase();
    fork;
      agt.run;
    join;
  endtask: run*/
  
endclass : environment

`endif
