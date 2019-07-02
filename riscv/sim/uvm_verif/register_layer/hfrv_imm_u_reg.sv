


class hfrv_imm_u_reg extends uvm_reg;
    `uvm_object_utils( hfrv_imm_u_reg)


    rand hfrv_imm_u_reg imm_reg;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 20 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        imm_reg = uvm_reg_field::type_id::create( "imm_reg" );
        imm_reg.configure(    .parent                 ( this ),
                                .size                   ( 20   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );

    endfunction : build

endclass : riscv_reg