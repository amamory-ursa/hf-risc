

`ifndef MONITOR__SV
`define MONITOR__SV

import uvm_pkg::*;

`include "../register_layer/hfrv_reg_block.sv"
`include "../uvm_src/instruction_item.sv"

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
    uvm_analysis_port #(instruction_item) item_collected_port;
	hfrv_tb_block   _hfrv_tb_block;

	extern function new(string name="monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : monitor

 
// ----------------------- IMPLEMENTATION --------------------------------


function monitor::new(string name="monitor", uvm_component parent);
	super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
endfunction : new

function void monitor::build_phase(uvm_phase phase);
	
	super.build_phase(phase);
    

endfunction : build_phase

function void monitor::connect_phase(uvm_phase phase);
    
    uvm_config_db#(hfrv_tb_block)::get(null, "uvm_test_top", "_hfrv_tb_block", _hfrv_tb_block);
endfunction : connect_phase

// run phase
task monitor::run_phase(uvm_phase phase);
    uvm_status_e      status;
    int               rdata;

    forever 
    begin
        @(posedge top_uvm.clk) 
        begin
                instruction_item tx = instruction_item::type_id::create();
                _hfrv_tb_block.register_block.pc_reg.read(status, rdata, UVM_BACKDOOR);
                //`uvm_info(get_type_name(), $sformatf("pc desired=0x%0h mirrored=0x%0h", _hfrv_tb_block.register_block.pc_reg.get(), _hfrv_tb_block.register_block.pc_reg.get_mirrored_value()), UVM_LOW);
                /*
                _hfrv_tb_block.register_block.ctrl_reg.read(status, rdata, UVM_BACKDOOR);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg desired=0x%0b mirrored=0x%0b", _hfrv_tb_block.register_block.ctrl_reg.get(), _hfrv_tb_block.register_block.ctrl_reg.get_mirrored_value()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg reg_write=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.reg_write.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg alu_src1=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.alu_src1.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg alu_src2=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.alu_src2.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg alu_op=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.alu_op.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg jump=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.jump.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg branch=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.branch.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg mem_write=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.mem_write.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg mem_read=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.mem_read.get()), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("ctrl_reg sig_read=0x%0b ", _hfrv_tb_block.register_block.ctrl_reg.sig_read.get()), UVM_LOW);
                //*/
                _hfrv_tb_block.register_block.inst_in_s_reg.read(status, rdata, UVM_BACKDOOR);
                //`uvm_info(get_type_name(), $sformatf("inst_in_s_ desired=0x%0b mirrored=0x%0b", _hfrv_tb_block.register_block.inst_in_s_reg.get(), _hfrv_tb_block.register_block.inst_in_s_reg.get_mirrored_value()[6:0]), UVM_LOW);
                //`uvm_info(get_type_name(), $sformatf("rdata=0x%0b", rdata[6:0]), UVM_LOW);
                
                tx.opcode = rdata[6:0];
                tx.rd = rdata[11:7];
                tx.r1 = rdata[19:15];
                tx.r2 = rdata[24:20];
                item_collected_port.write(tx);
        end
    end
endtask : run_phase



`endif 
