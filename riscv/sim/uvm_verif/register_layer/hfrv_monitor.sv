

`ifndef HFRV_MONITOR__SV
`define HFRV_MONITOR__SV

import uvm_pkg::*;

`include "../register_layer/hfrv_reg_block.sv"
`include "../uvm_src/instruction_item.sv"

class hfrv_monitor extends uvm_monitor;
  `uvm_component_utils(hfrv_monitor)

	hfrv_tb_block   _hfrv_tb_block;

	extern function new(string name="hfrv_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : hfrv_monitor

 
// ----------------------- IMPLEMENTATION --------------------------------


function hfrv_monitor::new(string name="hfrv_monitor", uvm_component parent);
	super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
endfunction : new

function void hfrv_monitor::build_phase(uvm_phase phase);
	
	super.build_phase(phase);
    

endfunction : build_phase

function void hfrv_monitor::connect_phase(uvm_phase phase);
    uvm_config_db#(hfrv_tb_block)::get(null, "uvm_test_top", "_hfrv_tb_block", _hfrv_tb_block);
endfunction : connect_phase

// run phase
task hfrv_monitor::run_phase(uvm_phase phase);
    uvm_status_e      status;
    int               rdata;

    forever 
    begin
        @(posedge top_uvm.clk) 
        begin
                // MIGRAR PARA MONITOR DA GEANINE
                instruction_item tx = instruction_item::type_id::create();
               
                _hfrv_tb_block.register_block.inst_in_s_reg.read(status, rdata, UVM_BACKDOOR);

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
                    `uvm_info(get_type_name(), $sformatf("bubble=0x%0b DETECTED BUBBLE ", bubble), UVM_LOW);
                end
                else
                begin
                    tx.instruction = rdata;
                    item_collected_port.write(tx);
                end
        end
    end
endtask : run_phase



`endif 
