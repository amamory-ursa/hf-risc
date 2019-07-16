`ifndef MONITOR_UVM
 `define MONITOR_UVM

 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "hfrv_interface.sv"
`include "memory_model.sv"
`include "../register_layer/hfrv_reg_block.sv"
`include "instruction_item.sv"



class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual hfrv_interface riscv_if;

	hfrv_tb_block   _hfrv_tb_block;
    uvm_analysis_port #(instruction_item) item_collected_port;

    uvm_event_pool p1;
    uvm_event terminated;


     ////////////////////////////////////////////////
   function new(string name="monitor", uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
  		super.build_phase(phase);
        
  		if (!uvm_config_db #(virtual hfrv_interface)::get (this,"", "riscv_if", riscv_if) )
            `uvm_fatal("NO_IF - MONITOR",{"virtual interface must be set for: ",get_full_name(),".riscv_if"});
		
	endfunction

    function void connect_phase(uvm_phase phase);
        uvm_config_db#(hfrv_tb_block)::get(null, "uvm_test_top", "_hfrv_tb_block", _hfrv_tb_block);
    endfunction : connect_phase

	task run_phase(uvm_phase phase);

		forever begin
		
            fork
                verify_terminate();
                time_out(phase);
                capture_instructions(phase);  
            join_any

            `uvm_info("MONITOR:","------------------------End of the program",UVM_LOW);
            
		    p1=uvm_event_pool::get_global_pool(); 
        	terminated = p1.get("p1");
        	
        	/*ativando evento*/
        	terminated.trigger();
        end

	endtask 

	task verify_terminate();
        // Waits inside the forever loop, watching the condition to finish the simulation!
        forever @(riscv_if.memory.mem) begin
            if (riscv_if.memory.mem.address == 32'he0000000 && riscv_if.memory.mem.data_we != 4'h0) begin
                riscv_if.memory.mem.data_read <= {32{1'b0}};
                break;
            end
        end
	endtask
	
    task time_out(uvm_phase phase);
		#20s
		`uvm_info("MONITOR:","timeout",UVM_LOW);
		//`uvm_fatal("TIMEOUT - MONITOR",{"TEMPO ACABOU"});
		//phase.drop_objection(this);
        `uvm_info("MONITOR:","End of the program",UVM_LOW);
    endtask
        
    task capture_instructions(uvm_phase phase);
        uvm_status_e      status, statusBubble;
        int               rdata, bubble;

        forever 
        begin
            @(posedge top_uvm.clk) 
            begin
                    instruction_item tx = instruction_item::type_id::create();
                
                    _hfrv_tb_block.register_block.inst_in_s_reg.read(status, rdata, UVM_BACKDOOR);
                    _hfrv_tb_block.register_block.bubble_reg.read(statusBubble, bubble, UVM_BACKDOOR);
                    // detect bubble
                    if (
                            (_hfrv_tb_block.register_block.bubble_reg.reg_to_mem_reg.get() ==1 ||
                            _hfrv_tb_block.register_block.bubble_reg.mem_to_reg.get() ==1 ||
                            _hfrv_tb_block.register_block.bubble_reg.except_reg.get() ==1 ||
                            _hfrv_tb_block.register_block.bubble_reg.branch_taken_reg.get() ==1 ||
                            _hfrv_tb_block.register_block.bubble_reg.jump_taken_reg.get() ==1 ||
                            _hfrv_tb_block.register_block.bubble_reg.bds_reg.get() ==1 
                            ) 
                        && _hfrv_tb_block.register_block.bubble_reg.mwait_reg.get() ==0 
                        && _hfrv_tb_block.register_block.bubble_reg.stall_reg.get() == 0
                    )
                    begin
                        `uvm_info(get_type_name(), $sformatf("bubble=0x%0b DETECTED BUBBLE ", bubble), UVM_HIGH);
                    end
                    else
                    begin
                        tx.instruction = rdata;
                        item_collected_port.write(tx);
                    end
            end
        end
    endtask : capture_instructions
   endclass
   `endif
