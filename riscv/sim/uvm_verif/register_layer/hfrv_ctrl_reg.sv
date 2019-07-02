


class hfrv_ctrl_reg extends uvm_reg;
    `uvm_object_utils( hfrv_ctrl_reg)


    rand uvm_reg_field reg_write;
    rand uvm_reg_field alu_src1;
    rand uvm_reg_field alu_src2;
    rand uvm_reg_field alu_op;
    rand uvm_reg_field jump;
    rand uvm_reg_field branch;
    rand uvm_reg_field mem_write;
    rand uvm_reg_field mem_read;
    rand uvm_reg_field sig_read;

    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 19 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        reg_write = uvm_reg_field::type_id::create( "reg_write" );
        reg_write.configure(    .parent                 ( this ),
                                .size                   ( 1   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        alu_src1 = uvm_reg_field::type_id::create( "alu_src1" );
        alu_src1.configure(    .parent                 ( this ),
                                .size                   ( 1   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        alu_src2 = uvm_reg_field::type_id::create( "alu_src2" );
        alu_src2.configure(    .parent                 ( this ),
                                .size                   ( 3   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        alu_op = uvm_reg_field::type_id::create( "alu_op" );
        alu_op.configure(    .parent                 ( this ),
                                .size                   ( 4   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        jump = uvm_reg_field::type_id::create( "jump" );
        jump.configure(    .parent                 ( this ),
                                .size                   ( 2   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        branch = uvm_reg_field::type_id::create( "branch" );
        branch.configure(    .parent                 ( this ),
                                .size                   ( 3   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        mem_write = uvm_reg_field::type_id::create( "mem_write" );
        mem_write.configure(    .parent                 ( this ),
                                .size                   ( 2   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        mem_read = uvm_reg_field::type_id::create( "mem_read" );
        mem_read.configure(    .parent                 ( this ),
                                .size                   ( 2   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        sig_read = uvm_reg_field::type_id::create( "sig_read" );
        sig_read.configure(    .parent                 ( this ),
                                .size                   ( 1   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );

    endfunction : build

endclass : riscv_reg