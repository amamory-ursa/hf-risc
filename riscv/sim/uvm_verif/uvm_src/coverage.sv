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
`include "instruction_item.sv"

class coverage extends uvm_subscriber #(instruction_item);
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
			{
			bins opcode[] = {3,19,23,35,51,55,99,103,111,115}; // restringir para codigos validos
			ignore_bins others = {[0:2],[4:18],[20:22],[24:34],[36:50],[52:54],[56:98],[100:102],[104:110],[112:114],[116:127]};

				option.weight = 0;}
		coverpoint iType
			{bins iType[] = {[0:6]}; 
			 option.weight = 0;}

		coverpoint rdRegister
			{bins rdRegister[] = {[0:31]}; // x0 nunca estará no rd
			 option.weight = 0;}

		coverpoint r1Register
			{bins r1Register[] = {[0:31]}; 
			 option.weight = 0;}

		coverpoint r2Register
			{bins r2Register[] = {[0:31]}; 
			 option.weight = 0;}


      		//cross opcode, rdRegister, r1Register, r2Register;
			  cross opcode, rdRegister;
	endgroup: CG_Instruction;



     	// Instantiate the covergroup
     	
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void write(instruction_item t);

endclass : coverage

function coverage::new(string name, uvm_component parent);
		super.new(name,parent);
		CG_Instruction = new();
endfunction : new


function void coverage::build_phase(uvm_phase phase);
	super.build_phase(phase);
    

endfunction : build_phase

function void coverage::write(instruction_item t);
	this.opcode = t.opcode;
	this.iType  = 0;
	this.rdRegister = t.rd;
	this.r1Register = t.r1;
	this.r2Register = t.r2;
	CG_Instruction.sample();
endfunction: write 

`endif // COVERAGE__SV
