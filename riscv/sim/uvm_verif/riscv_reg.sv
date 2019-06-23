


class riscv_reg extends uvm_reg;
    `uvm_object_utils( riscv_reg)


    rand uvm_reg_field registers[0:31];
    rand uvm_reg_field pc;


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 32 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();

        for (int i = 0; i < 32; i++)
            begin
                registers[i] = uvm_reg_field::type_id::create( $sformatf("register_%0d",i) );
                registers[i].configure( .parent                 ( this ),
                                .size                   ( 32    ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "WO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 1    ),
                                .individually_accessible( 0    ) );
        end
        pc  = uvm_reg_field::type_id::create( "pc" );
        pc.configure( .parent                 ( this ),
                                .size                   ( 32    ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "WO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 1    ),
                                .individually_accessible( 0    ) );

    endfunction : build

endclass : riscv_reg