


class hfrv_mem_reg extends uvm_reg;
    `uvm_object_utils( hfrv_mem_reg)


    rand uvm_reg_field mem_to_reg;
    rand uvm_reg_field reg_to_mem;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 2 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        mem_to_reg = uvm_reg_field::type_id::create( "mem_to_reg" );
        mem_to_reg.configure(    .parent                 ( this ),
                                .size                   ( 1   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        reg_to_mem = uvm_reg_field::type_id::create( "reg_to_mem" );
        reg_to_mem.configure(    .parent                 ( this ),
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