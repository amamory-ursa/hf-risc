

`ifndef INSTRUCTION_ITEM__SV
`define INSTRUCTION_ITEM__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class instruction_item extends uvm_sequence_item;
`uvm_object_utils(instruction_item);


	bit [6:0] opcode;
	bit [2:0] iType;
	bit [4:0] rd;
	bit [4:0] r1;
	bit [4:0] r2;
	

	function new(string name ="");
		super.new(name);
	endfunction

endclass : instruction_item

`endif
