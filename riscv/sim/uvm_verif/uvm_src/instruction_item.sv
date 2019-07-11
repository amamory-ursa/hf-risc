

`ifndef INSTRUCTION_ITEM__SV
`define INSTRUCTION_ITEM__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class instruction_item extends uvm_sequence_item;
`uvm_object_utils(instruction_item);


	/*
	bit [4:0] rd;
	bit [4:0] r1;
	bit [4:0] r2;
	bit [11:0] imm;
	bit [19:0] imm_u;
	bit [17:0] instruction; // concat funct7_funct3_opcode
	*/

	bit [31:0] instruction;
	

	function new(string name ="");
		super.new(name);
	endfunction

endclass : instruction_item

`endif
