`ifndef ENVIRONMENT_UVM
 `define ENVIRONMENT_UVM

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "agent.sv"
`include "coverage.sv"
`include "hfrv_interface.sv"
`include "scoreboard.sv"

class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  //Environment components
  agent agt;
  scoreboard scb;
  //checker ckr;
  coverage cov;
  hfrv_tb_block   _hfrv_tb_block;


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
      scb = new("scoreboard", this);

      // Creates the Checker


      // creates the coverage
      cov = coverage::type_id::create("coverage", this);
      
      

      // create register layer
      _hfrv_tb_block          = hfrv_tb_block::type_id::create ("_hfrv_tb_block", this);
      _hfrv_tb_block.build ();
      _hfrv_tb_block.lock_model ();
      uvm_config_db #(hfrv_tb_block)::set (null, "uvm_test_top", "_hfrv_tb_block", _hfrv_tb_block);
   

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
    agt.mon.item_collected_port.connect(cov.analysis_export);
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
