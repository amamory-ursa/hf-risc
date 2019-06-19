import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver.sv"  
`include "generator.sv"  


class agent extends uvm_agent;
  `uvm_component_utils(agent)

  driver    drv;
  _sequencer seqcr;
  generator gen;

 function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 

  function void build_phase(uvm_phase phase);
    
	virtual hfrv_interface riscv_if;
    	
	super.build_phase(phase);


    	if (!uvm_config_db #(virtual hfrv_interface)::get (this, "", "riscv_if", riscv_if) )
      	begin
        	uvm_config_db #(int)::dump(); 
        	`uvm_fatal("agnt", "No top_receive_if");
    	end

      	drv = driver::type_id::create("driver", this);
      	seqcr = _sequencer::type_id::create("sequencer", this);
      	uvm_config_db #(virtual hfrv_interface)::set (this,"driver", "riscv_if", riscv_if);
      	
      endfunction : build_phase

 
  function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqcr.seq_item_export);
  endfunction : connect_phase
 
endclass : agent
