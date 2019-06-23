/**********************************************************************
 * Functional coverage code
 *
 * Author: Chris Spear
 * Revision: 1.01
 * Last modified: 8/2/2011
 *
 * (c) Copyright 2008-2011, Chris Spear, Greg Tumbush. *** ALL RIGHTS RESERVED ***
 * http://chris.spear.net
 *
 *  This source file may be used and distributed without restriction
 *  provided that this copyright statement is not removed from the file
 *  and that any derivative work contains this copyright notice.
 *
 * Used with permission in the book, "SystemVerilog for Verification"
 * By Chris Spear and Greg Tumbush
 * Book copyright: 2008-2011, Springer LLC, USA, Springer.com
 *********************************************************************/

`ifndef COVERAGE__SV
`define COVERAGE__SV

import uvm_pkg::*;
`include "uvm_macros.svh"


class coverage extends uvm_subscriber #(wrapper_cell);
`uvm_component_utils(coverage);

	bit [6:0] opcode;
	bit [2:0] iType;
	bit [4:0] rdRegister;
	bit [4:0] r1Register;
	bit [4:0] r2Register;
//	bit [19:0] immRegister;
//	bit [1:0] immType;

	covergroup CG_Instruction;

		coverpoint opcode
			{bins opcode[] = {[0:600]};
				option.weight = 0;}
		coverpoint iType
			{bins iType[] = {[0:6]}; 
			 option.weight = 0;}

		coverpoint rdRegister
			{bins rdRegister[] = {[0:31]}; 
			 option.weight = 0;}

		coverpoint r1Register
			{bins r1Register[] = {[0:31]}; 
			 option.weight = 0;}

		coverpoint r2Register
			{bins r2Register[] = {[0:31]}; 
			 option.weight = 0;}


      		cross opcode, rdRegister, r1Register, r2Register;
	endgroup: CG_Instruction;



     	// Instantiate the covergroup
     	
	extern function new(string name, uvm_component parent);
	extern function void write(wrapper_cell t);

endclass : coverage

function coverage::new(string name, uvm_component parent);
		super.new(name,parent);
		CG_Instruction = new();
endfunction : new

function void coverage::write(instruction i);
	this.opcode = i.opcode;
	this.iType  = i.iType;
	this.rdRegister = i.rdRegister;
	this.r1Register = i.r1Register;
	this.r2Register = i.r2Register;
	CG_Instruction.sample();
endfunction: write 

`endif // COVERAGE__SV
