

`ifndef INSTRUCTION_ITEM__SV
`define INSTRUCTION_ITEM__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class instruction_item extends uvm_sequence_item;
`uvm_object_utils(instruction_item);


	bit [31:0] instruction;
	

	function new(string name ="");
		super.new(name);
	endfunction

endclass : instruction_item

`endif
