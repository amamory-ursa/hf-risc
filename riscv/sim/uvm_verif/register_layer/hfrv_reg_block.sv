



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

    uvm_reg_map     reg_map;
    
    string register_names[0:31] = {"Zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", 
                "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", 
                "s2", "s3", "s4", "s5", "s6","s7", "s8", "s9", "s10", "s11",
                "t3", "t4", "t5", "t6"}
    string imm_reg_names[0:3] = {"imm_i", "imm_s", "imm_sb", "imm_uj"}

            
 
    function new( string name = "hfrv_reg_block" );
        super.new( .name( name ), .has_coverage( UVM_NO_COVERAGE ) );
    endfunction: new

    virtual function void build();
        reg_map = create_map( .name( "reg_map" ), .base_addr( 8'h00 ), .n_bytes( 4 ), .endian( UVM_LITTLE_ENDIAN ) );      

        //--------------------------- GENERAL-PURPOSE REGISTERS
        int  offsetAddress = 8'h00;
        for (int i = 0; i < 31; i++)
        begin
            // colocar os nomes corretos em cada registrador
            int_regs[i] = hfrv_int_reg::type_id::create( register_names[i] );      
            int_regs[i].configure( .blk_parent( this ) );      
            int_regs[i].build(); 
            reg_map.add_reg( .rg( int_regs ), .offset( offsetAddress ), .rights( "WO" ) );
            offsetAddress += 8'h04;
        end
        //--------------------------- PC
        pc_reg = hfrv_int_reg::type_id::create( "pc_reg" );      
        pc_reg.configure( .blk_parent( this ) );      
        pc_reg.build(); 
        reg_map.add_reg( .rg( pc_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- PC_LAST
        pc_last_reg = hfrv_int_reg::type_id::create( "pc_last_reg" );      
        pc_last_reg.configure( .blk_parent( this ) );      
        pc_last_reg.build(); 
        reg_map.add_reg( .rg( pc_last_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- PC_LAST2
        pc_last2_reg = hfrv_int_reg::type_id::create( "pc_last2_reg" );      
        pc_last2_reg.configure( .blk_parent( this ) );      
        pc_last2_reg.build(); 
        reg_map.add_reg( .rg( pc_last2_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h04;
        //--------------------------- CONTROL
        ctrl_reg = hfrv_int_reg::type_id::create( "ctrl_reg" );      
        ctrl_reg.configure( .blk_parent( this ) );      
        ctrl_reg.build(); 
        reg_map.add_reg( .rg( ctrl_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h03;
        //--------------------------- MEMORY 
        mem_reg = hfrv_int_reg::type_id::create( "mem_reg" );      
        mem_reg.configure( .blk_parent( this ) );      
        mem_reg.build(); 
        mem_reg.add_reg( .rg( mem_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- IMMEDIATES
        for (int i = 0; i < 3; i++)
        begi
            // colocar os nomes corretos em cada registrador
            immediate_regs[i] = hfrv_int_reg::type_id::create( imm_reg_names[i] );      
            immediate_regs[i].configure( .blk_parent( this ) );      
            immediate_regs[i].build(); 
            reg_map.add_reg( .rg( immediate_regs ), .offset( offsetAddress ), .rights( "WO" ) );
            offsetAddress += 8'h04;
        end
        //--------------------------- RD
        rd_reg = hfrv_int_reg::type_id::create( "rd_reg" );      
        rd_reg.configure( .blk_parent( this ) );      
        rd_reg.build(); 
        reg_map.add_reg( .rg( rd_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS1
        rs1_reg = hfrv_int_reg::type_id::create( "rs1_reg" );      
        rs1_reg.configure( .blk_parent( this ) );      
        rs1_reg.build(); 
        reg_map.add_reg( .rg( rs1_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS2
        rs2_reg = hfrv_int_reg::type_id::create( "rs2_reg" );      
        rs2_reg.configure( .blk_parent( this ) );      
        rs2_reg.build(); 
        reg_map.add_reg( .rg( rs2_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h01;
        //--------------------------- RS2
        imm_u_reg = hfrv_int_reg::type_id::create( "imm_u_reg" );      
        imm_u_reg.configure( .blk_parent( this ) );      
        imm_u_reg.build(); 
        reg_map.add_reg( .rg( imm_u_reg  ), .offset( offsetAddress ), .rights( "RO" ) );      
        offsetAddress += 8'h03;
        
        lock_model(); // finalize the address mapping
    endfunction: build
endclass