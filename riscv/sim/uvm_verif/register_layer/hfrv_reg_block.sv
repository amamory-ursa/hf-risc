

`ifndef BLOCK_REG
`define BLOCK_REG

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "hfrv_ctrl_reg.sv"
`include "hfrv_imm_u_reg.sv"
`include "hfrv_int_reg.sv"
`include "hfrv_mem_reg.sv"
`include "hfrv_operand_reg.sv"

class hfrv_reg_block extends uvm_reg_block;
    `uvm_object_utils( hfrv_reg_block )
 
    rand hfrv_int_reg int_regs[0:31];
    rand hfrv_ctrl_reg ctrl_reg;
    rand hfrv_mem_reg mem_reg;
    rand hfrv_int_reg immediate_regs[0:3];
    rand hfrv_operand_reg rd_reg;
    rand hfrv_operand_reg rs1_reg;
    rand hfrv_operand_reg rs2_reg;
    rand hfrv_imm_u_reg imm_u_reg;
    rand hfrv_int_reg pc_reg;
    rand hfrv_int_reg pc_last_reg;
    rand hfrv_int_reg pc_last2_reg;

    rand hfrv_int_reg inst_in_s_reg;

    
    
    string register_names[0:31] = {"Zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", 
                "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", 
                "s2", "s3", "s4", "s5", "s6","s7", "s8", "s9", "s10", "s11",
                "t3", "t4", "t5", "t6"};
    string imm_reg_names[0:3] = {"imm_i", "imm_s", "imm_sb", "imm_uj"};

            
 
    function new( string name = "hfrv_reg_block" );
        super.new( .name( name ), .has_coverage( UVM_NO_COVERAGE ) );
    endfunction: new

    virtual function void build();
        int  offsetAddress = 8'h00;
        default_map = create_map( "", .base_addr( 8'h00 ), .n_bytes( 4 ), .endian( UVM_LITTLE_ENDIAN ) );      

        //--------------------------- GENERAL-PURPOSE REGISTERS
        
        for (int i = 0; i < 31; i++)
        begin
            // colocar os nomes corretos em cada registrador
            //int_regs[i] = hfrv_int_reg::type_id::create( register_names[i] );      
            int_regs[i] = hfrv_int_reg::type_id::create( $sformatf("int_regs[%d]",i) );      
            int_regs[i].configure( this, null, "" );      
            int_regs[i].build(); 
            int_regs[i].add_hdl_path_slice($sformatf("timer_%d",i), 0, int_regs[i].get_n_bits());
            default_map.add_reg( this.int_regs[i], .offset( offsetAddress ), .rights( "RO" ) );
            offsetAddress += 8'h04;
        end
        //--------------------------- PC
        pc_reg = hfrv_int_reg::type_id::create( "pc_reg" );      
        pc_reg.configure(  this, null, "" );      
        pc_reg.build(); 
        pc_reg.add_hdl_path_slice("pc", 0, pc_reg.get_n_bits());
        default_map.add_reg( .rg( pc_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- PC_LAST
        pc_last_reg = hfrv_int_reg::type_id::create( "pc_last_reg" );      
        pc_last_reg.configure( this, null, "" );      
        pc_last_reg.build(); 
        pc_last_reg.add_hdl_path_slice("pc_last", 0, pc_last_reg.get_n_bits());
        default_map.add_reg( .rg( pc_last_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- PC_LAST2
        pc_last2_reg = hfrv_int_reg::type_id::create( "pc_last2_reg" );      
        pc_last2_reg.configure( this, null, "" );      
        pc_last2_reg.build(); 
        pc_last2_reg.add_hdl_path_slice("pc_last2", 0, pc_last2_reg.get_n_bits());
        default_map.add_reg( .rg( pc_last2_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- CONTROL
        ctrl_reg = hfrv_ctrl_reg::type_id::create( "ctrl_reg" );      
        ctrl_reg.configure( this, null, "" );      
        ctrl_reg.build(); 
        //ctrl_reg.add_hdl_path_slice("reg_write_ctl_r", 0, ctrl_reg.get_n_bits());
        ctrl_reg.add_hdl_path_slice("reg_write_ctl_r", 0, 1);
        ctrl_reg.add_hdl_path_slice("alu_src1_ctl_r", 1, 1);
        ctrl_reg.add_hdl_path_slice("alu_src2_ctl_r", 2, 3);
        ctrl_reg.add_hdl_path_slice("alu_op_ctl_r", 5, 4);
        ctrl_reg.add_hdl_path_slice("jump_ctl_r", 9, 2);
        ctrl_reg.add_hdl_path_slice("branch_ctl_r", 11, 3);
        ctrl_reg.add_hdl_path_slice("mem_write_ctl_r", 14, 2);
        ctrl_reg.add_hdl_path_slice("mem_read_ctl_r", 16, 2);
        ctrl_reg.add_hdl_path_slice("sig_read_ctl_r", 18, 1);
        default_map.add_reg( .rg( ctrl_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h03;
        //--------------------------- MEMORY 
        mem_reg = hfrv_mem_reg::type_id::create( "mem_reg" );      
        mem_reg.configure( this, null, "" );      
        mem_reg.build(); 
        mem_reg.add_hdl_path_slice("mem_reg", 0, mem_reg.get_n_bits());
        default_map.add_reg( .rg( mem_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- IMMEDIATES
        for (int i = 0; i < 3; i++)
        begin 
            // colocar os nomes corretos em cada registrador
            immediate_regs[i] = hfrv_int_reg::type_id::create( imm_reg_names[i] );      
            immediate_regs[i].configure( this, null, "" );      
            immediate_regs[i].build(); 
            immediate_regs[i].add_hdl_path_slice($sformatf("immediate_regs_%d",i), 0, immediate_regs[i].get_n_bits());
            default_map.add_reg( .rg( immediate_regs[i] ), .offset( offsetAddress ), .rights( "RO" ) );
            offsetAddress += 8'h04;
        end
        //--------------------------- RD
        rd_reg = hfrv_operand_reg::type_id::create( "rd_reg" );      
        rd_reg.configure( this, null, "" );      
        rd_reg.build(); 
        rd_reg.add_hdl_path_slice("rd_reg", 0, rd_reg.get_n_bits());
        default_map.add_reg( .rg( rd_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS1
        rs1_reg = hfrv_operand_reg::type_id::create( "rs1_reg" );      
        rs1_reg.configure( this, null, "" );      
        rs1_reg.build(); 
        rs1_reg.add_hdl_path_slice("rs1_reg", 0, rs1_reg.get_n_bits());
        default_map.add_reg( .rg( rs1_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS2
        rs2_reg = hfrv_operand_reg::type_id::create( "rs2_reg" );      
        rs2_reg.configure( this, null, "" );      
        rs2_reg.build(); 
        rs2_reg.add_hdl_path_slice("rs2_reg", 0, rs2_reg.get_n_bits());
        default_map.add_reg( .rg( rs2_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS2
        imm_u_reg = hfrv_imm_u_reg::type_id::create( "imm_u_reg" );      
        imm_u_reg.configure( this, null, "" );      
        imm_u_reg.build(); 
        imm_u_reg.add_hdl_path_slice("imm_u_reg", 0, imm_u_reg.get_n_bits());
        default_map.add_reg( .rg( imm_u_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h03;

        //--------------------------- inst_in_s
        inst_in_s_reg = hfrv_int_reg::type_id::create( "inst_in_s_reg" );      
        inst_in_s_reg.configure( this, null, "" );      
        inst_in_s_reg.build(); 
        inst_in_s_reg.add_hdl_path_slice("inst_in_s", 0, inst_in_s_reg.get_n_bits());
        default_map.add_reg( .rg( inst_in_s_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        
        
        add_hdl_path("riscv.cpu.core");
        lock_model(); // finalize the address mapping
    endfunction: build
endclass



class hfrv_tb_block extends uvm_reg_block;
    rand hfrv_reg_block register_block;

	`uvm_object_utils(hfrv_tb_block)
	function new(string name = "hfrv_tb_block");
		super.new(name);
	endfunction

	function void build();
    default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
    register_block = hfrv_reg_block::type_id::create("register_block",,get_full_name());
    register_block.configure(this, "riscv.cpu.core");
    register_block.build();
    add_hdl_path("top_uvm");
    default_map.add_submap(this.register_block.default_map, `UVM_REG_ADDR_WIDTH'h0);
	endfunction
endclass


`endif 
