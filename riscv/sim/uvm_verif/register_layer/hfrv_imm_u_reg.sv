

`ifndef IMM_U_REG
`define IMM_U_REG

`include "uvm_macros.svh"
import uvm_pkg::*;



class hfrv_imm_u_reg extends uvm_reg;
    `uvm_object_utils( hfrv_imm_u_reg)


    rand uvm_reg_field imm_reg;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 20 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        // apenas x0 serah RO (fazer por DB)
        imm_reg = uvm_reg_field::type_id::create( "imm_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        imm_reg.configure(  .parent                 ( this ),
                            .size                   ( 20   ),
                            .lsb_pos                ( 0    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );

    endfunction : build

endclass : hfrv_imm_u_reg


`endif
