

`ifndef BUBBLE_REG
`define BUBBLE_REG

`include "uvm_macros.svh"
import uvm_pkg::*;



class hfrv_bubble_reg extends uvm_reg;
    `uvm_object_utils( hfrv_bubble_reg )


    rand uvm_reg_field reg_to_mem_reg;
    rand uvm_reg_field mem_to_reg;
    rand uvm_reg_field except_reg;
    rand uvm_reg_field branch_taken_reg;
    rand uvm_reg_field jump_taken_reg;
    rand uvm_reg_field bds_reg;
    rand uvm_reg_field mwait_reg;
    rand uvm_reg_field irq_ack_s_reg;
    rand uvm_reg_field stall_reg;
    


    function new(string name = "riscv_reg");
        super.new( .name( name ), .n_bits( 9 ), .has_coverage( UVM_NO_COVERAGE ) );     
    endfunction

    virtual function void build();
        reg_to_mem_reg = uvm_reg_field::type_id::create( "reg_to_mem_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        reg_to_mem_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 0    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        mem_to_reg = uvm_reg_field::type_id::create( "mem_to_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        mem_to_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 1    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        except_reg = uvm_reg_field::type_id::create( "except_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        except_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 2    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        branch_taken_reg = uvm_reg_field::type_id::create( "branch_taken_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        branch_taken_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 3    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        jump_taken_reg = uvm_reg_field::type_id::create( "jump_taken_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        jump_taken_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 4    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        bds_reg = uvm_reg_field::type_id::create( "bds_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        bds_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 5    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        mwait_reg = uvm_reg_field::type_id::create( "mwait_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        mwait_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 6    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        irq_ack_s_reg = uvm_reg_field::type_id::create( "irq_ack_s_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        irq_ack_s_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 7    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );
        stall_reg = uvm_reg_field::type_id::create( "stall_reg" );
        // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible); 
        stall_reg.configure(  .parent                 ( this ),
                            .size                   ( 1   ),
                            .lsb_pos                ( 8    ),
                            .access                 ( "RO" ),
                            .volatile               ( 0    ),
                            .reset                  ( 0    ),
                            .has_reset              ( 1    ),
                            .is_rand                ( 0    ),
                            .individually_accessible( 0    ) );


    endfunction : build

endclass : hfrv_bubble_reg


`endif
