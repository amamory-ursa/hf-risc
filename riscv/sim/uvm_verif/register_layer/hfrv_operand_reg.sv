
`ifndef OPERAND_REG
`define OPERAND_REG

class hfrv_operand_reg extends uvm_reg;
    `uvm_object_utils( hfrv_operand_reg)


    rand uvm_reg_field operand_reg;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 5 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        operand_reg = uvm_reg_field::type_id::create( "operand_reg" );
        operand_reg.configure(    .parent                 ( this ),
                                .size                   ( 5   ),
                                .lsb_pos                ( 0    ),
                                .access                 ( "RO" ),
                                .volatile               ( 0    ),
                                .reset                  ( 0    ),
                                .has_reset              ( 1    ),
                                .is_rand                ( 0    ),
                                .individually_accessible( 0    ) );

    endfunction : build

endclass : hfrv_operand_reg

`endif 
