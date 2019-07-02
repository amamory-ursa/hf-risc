

`ifndef MONITOR__SV
`define MONITOR__SV

import uvm_pkg::*;

`include "../register_layer/hfrv_reg_block.sv"

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

	hfrv_tb_block   _hfrv_tb_block;

	extern function new(string name="monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : monitor

 
// ----------------------- IMPLEMENTATION --------------------------------


function monitor::new(string name="monitor", uvm_component parent);
	super.new(name, parent);
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
        @(posedge top_uvm.clk) begin
                _hfrv_tb_block.register_block.pc_reg.read(status, rdata, UVM_BACKDOOR);
                `uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", _hfrv_tb_block.register_block.pc_reg.get(), _hfrv_tb_block.register_block.pc_reg.get_mirrored_value()), UVM_LOW)
        end
    end
endtask : run_phase


`endif 
