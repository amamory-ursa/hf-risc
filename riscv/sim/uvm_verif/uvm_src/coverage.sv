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
	bit [11:0] imm_12;
	bit [19:0] imm_20;
//	bit [19:0] immRegister;
//	bit [1:0] immType;
    bit [17:0] instruction;
	

	covergroup CG_Instruction;

/*		coverpoint opcode
			{
			bins opcode[] = {3,19,23,35,51,55,99,103,111,115}; // restringir para codigos validos
			ignore_bins others = {[0:2],[4:18],[20:22],[24:34],[36:50],[52:54],[56:98],[100:102],[104:110],[112:114],[116:127]};

				option.weight = 0;}*/
		/*coverpoint iType
			{bins iType[] = {[0:6]}; 
			 option.weight = 0;}*/
/*
		coverpoint rdRegister
			{bins rdRegister[] = {[0:31]}; // x0 nunca estará no rd
			 option.weight = 0;}

		coverpoint r1Register
			{bins r1Register[] = {[0:31]}; 
			 option.weight = 0;}

		coverpoint r2Register
			{bins r2Register[] = {[0:31]}; 
			 option.weight = 0;}
*/
		coverpoint instruction 
		{
			bins LUI    = {17'b0000000_000_0110111};

  			bins AUIPC  = {17'b0000000_000_0010111};

  			bins JAL    = {17'b0000000_000_1101111};

  			bins JALR   = {17'b0000000_000_1100111};

			bins BEQ 	= {17'b0000000_000_1100011};
			bins BNE 	= {17'b0000000_001_1100011};
			bins BLT 	= {17'b0000000_100_1100011};
			bins BGE 	= {17'b0000000_101_1100011};
			bins BLTU   = {17'b0000000_110_1100011};
			bins BGEU   = {17'b0000000_111_1100011};

			bins LB  	= {17'b0000000_000_0000011};
			bins LH  	= {17'b0000000_001_0000011};
			bins LW  	= {17'b0000000_010_0000011};
			bins LBU 	= {17'b0000000_100_0000011};
			bins LHU 	= {17'b0000000_101_0000011};

			bins SB  	= {17'b0000000_000_0100011};
			bins SH  	= {17'b0000000_001_0100011};
			bins SW  	= {17'b0000000_010_0100011};

			bins ADDI   = {17'b0000000_000_0010011};
			bins SLTI   = {17'b0000000_010_0010011};
			bins SLTIU  = {17'b0000000_011_0010011};
			bins XORI   = {17'b0000000_100_0010011};
			bins ORI 	= {17'b0000000_110_0010011};
			bins ANDI   = {17'b0000000_111_0010011};
			bins SLLI   = {17'b0000000_001_0010011};
			bins SRLI   = {17'b0000000_101_0010011};
			bins SRAI   = {17'b0100000_101_0010011};

			bins ADD 	= {17'b0000000_000_0110011};
			bins SUB 	= {17'b0100000_000_0110011};
			bins SLL 	= {17'b0000000_001_0110011};
			bins SLT 	= {17'b0000000_010_0110011};
			bins SLTU   = {17'b0000000_011_0110011};
			bins XOR 	= {17'b0000000_100_0110011};
			bins SRL 	= {17'b0000000_101_0110011};
			bins SRA 	= {17'b0100000_101_0110011};
			bins OR  	= {17'b0000000_110_0110011};
			bins AND 	= {17'b0000000_111_0110011};
			
			bins ECALL  = {17'b0000000_000_1110011};
			bins EBREAK = {17'b0000001_000_1110011};
		}

      	
	endgroup: CG_Instruction;

	// ------------------------------------ R TYPE 
	covergroup CG_R_TypeInstructions;
		coverpoint rdRegister
		{
			bins rdRegister[] = {[0:31]}; // x0 nunca estará no rd
			option.weight = 0;
		}

		coverpoint r1Register
		{
			bins r1Register[] = {[0:31]}; 
			option.weight = 0;
		}

		coverpoint r2Register
		{
				bins r2Register[] = {[0:31]}; 
			 	option.weight = 0;
		}

		coverpoint instruction 
		{		
			bins ADD 	= {17'b0000000_000_0110011};
			bins SUB 	= {17'b0100000_000_0110011};
			bins SLL 	= {17'b0000000_001_0110011};
			bins SLT 	= {17'b0000000_010_0110011};
			bins SLTU   = {17'b0000000_011_0110011};
			bins XOR 	= {17'b0000000_100_0110011};
			bins SRL 	= {17'b0000000_101_0110011};
			bins SRA 	= {17'b0100000_101_0110011};
			bins OR  	= {17'b0000000_110_0110011};
			bins AND 	= {17'b0000000_111_0110011};
		}
		cross instruction, rdRegister, r1Register, r2Register;
	endgroup : CG_R_TypeInstructions

	// ------------------------------------ I TYPE 
	covergroup CG_I_TypeInstructions;
		coverpoint rdRegister
		{
			bins rdRegister[] = {[0:31]}; // x0 nunca estará no rd
			option.weight = 0;
		}

		coverpoint r1Register
		{
			bins r1Register[] = {[0:31]}; 
			option.weight = 0;
		}

		coverpoint imm_12
		{
				bins lowest[]  = {12'b00_000_000_000}; 
				bins middle[]  = {12'b10_000_000_000}; 
				bins highest[] = {12'b11_111_111_111}; 
			 	option.weight = 0;
		}

		coverpoint instruction 
		{		
			bins LB  	= {17'b0000000_000_0000011};
			bins LH  	= {17'b0000000_001_0000011};
			bins LW  	= {17'b0000000_010_0000011};
			bins LBU 	= {17'b0000000_100_0000011};
			bins LHU 	= {17'b0000000_101_0000011};

			bins ADDI   = {17'b0000000_000_0010011};
			bins SLTI   = {17'b0000000_010_0010011};
			bins SLTIU  = {17'b0000000_011_0010011};
			bins XORI   = {17'b0000000_100_0010011};
			bins ORI 	= {17'b0000000_110_0010011};
			bins ANDI   = {17'b0000000_111_0010011};
			bins SLLI   = {17'b0000000_001_0010011};
			bins SRLI   = {17'b0000000_101_0010011};
			bins SRAI   = {17'b0100000_101_0010011};
		}
		cross instruction, rdRegister, r1Register;
		cross instruction, imm_12;
	endgroup : CG_I_TypeInstructions

	// ------------------------------------ S TYPE 
	covergroup CG_S_TypeInstructions;
		

		coverpoint r1Register
		{
			bins r1Register[] = {[0:31]}; 
			option.weight = 0;
		}

		coverpoint r2Register
		{
				bins r2Register[] = {[0:31]}; 
			 	option.weight = 0;
		}

		coverpoint imm_12
		{
				bins lowest[]  = {12'b00_000_000_000}; 
				bins middle[]  = {12'b10_000_000_000}; 
				bins highest[] = {12'b11_111_111_111}; 
			 	option.weight = 0;
		}

		coverpoint instruction 
		{		

			bins SB  	= {17'b0000000_000_0100011};
			bins SH  	= {17'b0000000_001_0100011};
			bins SW  	= {17'b0000000_010_0100011};
		}
		cross instruction, r1Register;
	endgroup : CG_S_TypeInstructions

	// ------------------------------------ SB TYPE 
	covergroup CG_SB_TypeInstructions;
		

		coverpoint r1Register
		{
			bins r1Register[] = {[0:31]}; 
			option.weight = 0;
		}

		/*coverpoint imm
		{
				bins imm[] = {[0:31]}; 
			 	option.weight = 0;
		}*/

		coverpoint instruction 
		{		
			bins BEQ 	= {17'b0000000_000_1100011};
			bins BNE 	= {17'b0000000_001_1100011};
			bins BLT 	= {17'b0000000_100_1100011};
			bins BGE 	= {17'b0000000_101_1100011};
			bins BLTU   = {17'b0000000_110_1100011};
			bins BGEU   = {17'b0000000_111_1100011};
		}
		cross instruction, r1Register;
	endgroup : CG_SB_TypeInstructions

	// ------------------------------------ U TYPE 
	covergroup CG_U_TypeInstructions;
		


		
		coverpoint rdRegister
		{
			bins rdRegister[] = {[0:31]}; 
			option.weight = 0;
		}

		coverpoint imm_20
		{
				bins lowest[]  = {20'b00_000_000_000_000_000_000}; 
				bins middle[]  = {20'b10_000_000_000_000_000_000}; 
				bins highest[] = {20'b11_111_111_111_111_111_111}; 
			 	option.weight = 0;
		}

		coverpoint instruction
		{		

			bins LUI    = {17'b0000000_000_0110111};

  			bins AUIPC  = {17'b0000000_000_0010111};
		}
		cross instruction, rdRegister;
		cross instruction, imm_20;
	endgroup : CG_U_TypeInstructions

	// ------------------------------------ UJ TYPE 
	covergroup CG_UJ_TypeInstructions;
		

		coverpoint rdRegister
		{
			bins rdRegister[] = {[0:31]}; 
			option.weight = 0;
		}

		/*coverpoint imm
		{
				bins imm[] = {[0:31]}; 
			 	option.weight = 0;
		}*/

		coverpoint instruction 
		{		

			bins JAL    = {17'b0000000_000_1101111};
  			bins JALR   = {17'b0000000_000_1100111};
		}
		cross instruction, rdRegister;

	endgroup : CG_UJ_TypeInstructions



     	// Instantiate the covergroup
     	
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void write(instruction_item t);

endclass : coverage

function coverage::new(string name, uvm_component parent);
		super.new(name,parent);
		CG_Instruction = new();
		CG_R_TypeInstructions = new();
		CG_I_TypeInstructions = new();
		CG_S_TypeInstructions = new();
		CG_SB_TypeInstructions = new();
		CG_U_TypeInstructions = new();
		CG_UJ_TypeInstructions = new();
endfunction : new


function void coverage::build_phase(uvm_phase phase);
	super.build_phase(phase);
    

endfunction : build_phase

function void coverage::write(instruction_item t);
	this.instruction = 0;
	
	if (t.instruction[6:0] == 7'b0110011) // coverage R-TYPE
	begin
		this.instruction[17:11] = t.instruction[31:25];		//funct7
		this.instruction[10:7] = t.instruction[14:12];     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.rdRegister = t.instruction[11:7];
		this.r1Register = t.instruction[19:15];
		this.r2Register = t.instruction[24:20];
		CG_R_TypeInstructions.sample();
	end
	if (t.instruction[6:0] == 7'b0000011 || t.instruction[6:0] == 7'b0010011 ) // coverage I-TYPE
	begin
		bit [11:0] t_imm;
		this.instruction[17:11] = 7'b0_000_000;				//funct7
		this.instruction[10:7] = t.instruction[14:12];     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.rdRegister = t.instruction[11:7];
		this.r1Register = t.instruction[19:15];
		t_imm = t.instruction[31:20];
		if (12'b00_000_000_000 <= t_imm && t_imm <= 12'b00_000_000_111)
			this.imm_12 = 12'b00_000_000_000;
		if (12'b00_000_001_000 <= t_imm && t_imm < 12'b11_111_111_000)
			this.imm_12 = 12'b10_000_000_000;
		if (12'b11_111_111_000 <= t_imm && t_imm <= 12'b11_111_111_111)
			this.imm_12 = 12'b11_111_111_111;

		CG_I_TypeInstructions.sample();
	end
	if (t.instruction[6:0] == 7'b0100011 ) // coverage S-TYPE
	begin
		bit [11:0]t_imm;
		this.instruction[17:11] = 7'b0_000_000;				//funct7
		this.instruction[10:7] = t.instruction[14:12];     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.rdRegister = t.instruction[11:7];
		this.r1Register = t.instruction[19:15];
		t_imm[11:5] = t.instruction[31:25];					// immediate
		t_imm[4:0] = t.instruction[11:7];					// immediate
		if (12'b00_000_000_000 <= t_imm && t_imm <= 12'b00_000_000_111)
			this.imm_12 = 12'b00_000_000_000;
		if (12'b00_000_001_000 <= t_imm && t_imm < 12'b11_111_111_000)
			this.imm_12 = 12'b10_000_000_000;
		if (12'b11_111_111_000 <= t_imm && t_imm <= 12'b11_111_111_111)
			this.imm_12 = 12'b11_111_111_111;
		CG_S_TypeInstructions.sample();
	end
	if (t.instruction[6:0] == 7'b1100011 ) // coverage SB-TYPE
	begin
		this.instruction[17:11] = 7'b0_000_000;				//funct7
		this.instruction[10:7] = t.instruction[14:12];     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.r1Register = t.instruction[19:15];
		this.r2Register = t.instruction[24:20];
		CG_SB_TypeInstructions.sample();
	end

	if (t.instruction[6:0] == 7'b0010111 ) // coverage U-TYPE
	begin
		bit [19:0] t_imm;
		this.instruction[17:11] = 7'b0_000_000;				//funct7
		this.instruction[10:7] = 3'b000;     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.rdRegister = t.instruction[11:7];
		t_imm[19:0] = t.instruction[31:12];
		if (20'b00_000_000_000_000_000_000 <= t_imm && t_imm <= 20'b00_000_000_000_000_000_111)
			this.imm_20 = 20'b00_000_000_000_000_000_000;
		if (20'b00_000_000_000_000_001_000 <= t_imm && t_imm < 20'b11_111_111_111_111_111_000)
			this.imm_20 = 20'b10_000_000_000_000_000_000;
		if (20'b11_111_111_111_111_111_000 <= t_imm && t_imm <= 20'b11_111_111_111_111_111_111)
			this.imm_20 = 20'b11_111_111_111_111_111_111;
		CG_U_TypeInstructions.sample();
	end

	if (t.instruction[6:0] == 7'b1101111 || t.instruction[6:0] == 7'b1100111 ) // coverage UJ-TYPE
	begin
		this.instruction[17:11] = 7'b0_000_000;				//funct7
		this.instruction[10:7] = 3'b000;     //funct3           
		this.instruction[6:0] = t.instruction[6:0];			//opcode
		this.rdRegister = t.instruction[11:7];
		// add immediates
		if (this.instruction == 17'b0000000_000_1101111) // JAL
		begin
		
			bit [19:0] t_imm;
			
			this.r1Register = -1;
			t_imm[19:0] = t.instruction[31:12];
			if (20'b00_000_000_000_000_000_000 <= t_imm && t_imm <= 20'b00_000_000_000_000_000_111)
				this.imm_20 = 20'b00_000_000_000_000_000_000;
			if (20'b00_000_000_000_000_001_000 <= t_imm && t_imm < 20'b11_111_111_111_111_111_000)
				this.imm_20 = 20'b10_000_000_000_000_000_000;
			if (20'b11_111_111_111_111_111_000 <= t_imm && t_imm <= 20'b11_111_111_111_111_111_111)
				this.imm_20 = 20'b11_111_111_111_111_111_111;
		end
		if (this.instruction == 17'b0000000_000_1100111) // JALR
		begin
		
			bit [11:0] t_imm;
			
			this.r1Register = t.instruction[19:15];;
			t_imm = t.instruction[31:20];
			if (12'b00_000_000_000 <= t_imm && t_imm <= 12'b00_000_000_111)
				this.imm_12 = 12'b00_000_000_000;
			if (12'b00_000_001_000 <= t_imm && t_imm < 12'b11_111_111_000)
				this.imm_12 = 12'b10_000_000_000;
			if (12'b11_111_111_000 <= t_imm && t_imm <= 12'b11_111_111_111)
				this.imm_12 = 12'b11_111_111_111;
		end
		CG_UJ_TypeInstructions.sample();
	end

	// simple resume
	CG_Instruction.sample();
endfunction: write 

`endif // COVERAGE__SV
