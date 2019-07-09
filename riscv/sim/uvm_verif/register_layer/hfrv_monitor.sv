

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
    uvm_status_e      status, status2;
    int               rdata,rdata2;
    int               old_pc;
    int               old_opcode;
    int               old_funct3;
    int               old_funct7;
    int               old_inst_in_s;

    forever 
    begin
        @(posedge top_uvm.clk) 
        begin
                instruction_item tx = instruction_item::type_id::create();
                _hfrv_tb_block.register_block.pc_reg.read(status, rdata, UVM_BACKDOOR);
                if (old_pc == rdata)
                begin
                    `uvm_info(get_type_name(), $sformatf("pc=0x%0h old_pc=0x%0h old_opcode=0x%0h(%0b) funct3=%0b funct7=0x%0h", rdata, old_pc, old_opcode, old_opcode,old_funct3,old_funct7), UVM_LOW);
                    _hfrv_tb_block.register_block.inst_in_s_reg.read(status2, rdata2, UVM_BACKDOOR);
                    `uvm_info(get_type_name(), $sformatf("inst_in_s_reg=0x%0h old_inst_in_s=0x%0h", rdata2, old_inst_in_s), UVM_LOW);
                end

                old_pc = rdata;
                _hfrv_tb_block.register_block.inst_in_s_reg.read(status, rdata, UVM_BACKDOOR);
                old_inst_in_s = rdata;
                old_opcode = rdata[6:0];
                old_funct3 = rdata[14:12];
                old_funct7 = rdata[31:25];
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
                /*
                `uvm_info(get_type_name(), "--------------------------------------------", UVM_LOW);
                _hfrv_tb_block.register_block.inst_in_s_reg.read(status, rdata, UVM_BACKDOOR);
                `uvm_info(get_type_name(), $sformatf("inst_in_s_ desired=0x%0b (0x%0h)mirrored=0x%0b", _hfrv_tb_block.register_block.inst_in_s_reg.get(),  _hfrv_tb_block.register_block.inst_in_s_reg.get(), _hfrv_tb_block.register_block.inst_in_s_reg.get_mirrored_value()[6:0]), UVM_LOW);
                `uvm_info(get_type_name(), $sformatf("rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b0110111)
                
                    `uvm_info(get_type_name(), $sformatf("LUI rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b00_101_11)
                begin
//                    int data;
                    //data[11:0]=0;
                    //data[31:12]=rdata[31:12];
                    `uvm_info(get_type_name(), $sformatf("AUIPC rdata=0x%0b rd=0x%0b imm: 0x%0h", rdata[6:0],rdata[11:7],rdata[31:12]), UVM_LOW);
//                    `uvm_info(get_type_name(), $sformatf("pc desired=0x%0h mirrored=0x%0h", _hfrv_tb_block.register_block.pc_reg.get(), _hfrv_tb_block.register_block.pc_reg.get_mirrored_value()), UVM_LOW);
//                    `uvm_info(get_type_name(), $sformatf("pc_last desired=0x%0h mirrored=0x%0h", _hfrv_tb_block.register_block.pc_last_reg.get(), _hfrv_tb_block.register_block.pc_last_reg.get_mirrored_value()), UVM_LOW);
//                    `uvm_info(get_type_name(), $sformatf("data=0x%0h",data), UVM_LOW);
//                    `uvm_info(get_type_name(), $sformatf("register=0x%0h", _hfrv_tb_block.register_block.int_regs[2].get()), UVM_LOW);
                end
                if (rdata[6:0]== 7'b11_011_11)
                    `uvm_info(get_type_name(), $sformatf("JAL rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b11_001_11)
                    `uvm_info(get_type_name(), $sformatf("JALR rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b11_000_11)
                    `uvm_info(get_type_name(), $sformatf("BRANCH rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b00_000_11)
                    `uvm_info(get_type_name(), $sformatf("LOAD rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b01_000_11)
                    `uvm_info(get_type_name(), $sformatf("STORE rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b00_100_11)
                begin
                    `uvm_info(get_type_name(), $sformatf("IMM opcode=0x%0b", rdata[6:0]), UVM_LOW);
                    `uvm_info(get_type_name(), $sformatf("---     rd=0x%0b", rdata[11:7]), UVM_LOW);
                    `uvm_info(get_type_name(), $sformatf("--- funct3=0x%0b", rdata[14:12]), UVM_LOW);
                    `uvm_info(get_type_name(), $sformatf("---    rs1=0x%0b", rdata[19:15]), UVM_LOW);
                    `uvm_info(get_type_name(), $sformatf("---    imm=0x%0b", rdata[31:20]), UVM_LOW);
                    if (rdata[11:7]==0 && rdata[19:15]==0 && rdata[31:20]==0)
                        `uvm_info(get_type_name(), "------- NOT OPERATION DETECTED -------", UVM_LOW);
                end
                if (rdata[6:0]== 7'b01_100_11)
                    `uvm_info(get_type_name(), $sformatf("OP rdata=0x%0b", rdata[6:0]), UVM_LOW);
                if (rdata[6:0]== 7'b11_100_11)
                    `uvm_info(get_type_name(), $sformatf("SYSTEM rdata=0x%0b", rdata[6:0]), UVM_LOW);
*/

                tx.opcode = rdata[6:0];
                tx.rd = rdata[11:7];
                tx.r1 = rdata[19:15];
                tx.r2 = rdata[24:20];
                tx.instruction[16:10] = rdata[31:25];
                tx.instruction[9:7] = rdata[9:7];
                tx.instruction[6:0] = rdata[6:0];
                item_collected_port.write(tx);
        end
    end
endtask : run_phase



`endif 
