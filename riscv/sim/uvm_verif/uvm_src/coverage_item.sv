

`ifndef COVERAGE_ITEM__SV
`define COVERAGE_ITEM__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef struct
{
    string text;
    int value;
} pair;

class coverage_item extends uvm_sequence_item;
`uvm_object_utils(coverage_item);


	pair _instruction[$];
    pair _cross[$];


	function new(string name ="");
		super.new(name);
	endfunction

    function printAll();

        for ( int i = 0; i < _instruction.size;i++)
        begin
            `uvm_info(get_type_name(), $sformatf("%d - %s: %d ", i, _instruction[i].text, _instruction[i].value), UVM_LOW);            
        end
        for ( int i = 0; i < _cross.size;i++)
        begin
            `uvm_info(get_type_name(), $sformatf("%d - %s: %d ", i, _cross[i].text, _cross[i].value), UVM_LOW);            
        end
    endfunction

endclass : coverage_item

`endif
