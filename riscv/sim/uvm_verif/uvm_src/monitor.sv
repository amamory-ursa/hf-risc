`ifndef MONITOR_UVM
 `define MONITOR_UVM

 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "hfrv_interface.sv"
`include "memory_model.sv"



class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual hfrv_interface riscv_if;

    uvm_event_pool p1;
    uvm_event terminated;
     ////////////////////////////////////////////////
   function new(string name="monitor", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
  		super.build_phase(phase);

  		if (!uvm_config_db #(virtual hfrv_interface)::get (this,"", "riscv_if", riscv_if) )
            `uvm_fatal("NO_IF - MONITOR",{"virtual interface must be set for: ",get_full_name(),".riscv_if"});
		
	endfunction

	task run_phase(uvm_phase phase);

		//while(1)
		//begin

		phase.raise_objection(this);
		

		verify_terminate();

        	p1=uvm_event_pool::get_global_pool(); 
        	terminated = p1.get("p1");
        	
        	/*ativando evento*/
        	terminated.trigger();

        	phase.drop_objection(this);
    	//end
	endtask 

	 task verify_terminate();
        // Waits inside the forever loop, watching the condition to finish the simulation!
        forever @(riscv_if.memory.mem) begin
            if (riscv_if.memory.mem.address == 32'he0000000 && riscv_if.memory.mem.data_we != 4'h0) begin
                riscv_if.memory.mem.data_read <= {32{1'b0}};

        	`uvm_info("MONITOR:","End of the program",UVM_LOW);
                break;
            end
        end
        


    endtask



   endclass
   `endif
