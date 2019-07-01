


class hfrv_int_reg extends uvm_reg;
    `uvm_object_utils( hfrv_int_reg)


    rand uvm_reg_field register;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        register = uvm_reg_field::type_id::create( "register" );
        register.configure(    .parent                 ( this ),
                                .size                   ( 32   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "WO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );
        


    endfunction : build

endclass : riscv_reg