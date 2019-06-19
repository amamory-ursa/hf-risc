`ifndef DRIVER_UVM
 `define DRIVER_UVM

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "hfrv_interface.sv"
`include "memory_model.sv"

class driver extends uvm_driver#(memory_model);
    `uvm_component_utils(driver)

    // RISC-V Processor (DUT) Interface
    virtual hfrv_interface riscv_if;

    // Port to inform the transaction to the Scoreboard and Coverage
    uvm_analysis_port#(memory_model) dvr2scb_port;

    memory_model req, boot;

    /////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    /////////////////////////////////////////////////
    // Build phase
    ////////////////////////////////////////////////
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Gets the processor interface
        if(!uvm_config_db#(virtual hfrv_interface)::get(this, "", "riscv_if", riscv_if))
            `uvm_fatal("NO_IF - DRIVER",{"virtual interface must be set for: ",get_full_name(),".riscv_if"});

        // To inform the Scoreboard and the Coverage
        dvr2scb_port = new("dvr2scb_port", this);

        // Creates the ROM memory transaction
        boot = memory_model::type_id::create();
        // Reads the boot.txt to get the ROM memory content
        boot.read_from_file("boot.txt", 'h0, 'h100000);

    endfunction: build_phase


    /////////////////////////////////////////////////
    // Run phase
            /*forever begin
                automatic memory_model trans;
                gen2agt.get(trans);
                agt2scb.put(trans);
                ->start_scb;
                feed_dut(trans);
                @(terminated);
                halt_dut();
            end*/
    ////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
        riscv_if.reset = 1;
        riscv_if.stall = 0;
        #10;
        forever begin
            // Gets a new program from the sequencer
            seq_item_port.get_next_item(req);
            
            dvr2scb_port.write(req);

            // Provide the program to the processor!
            drive();
            
            // Inform that the program was consumed by DUT
            seq_item_port.item_done();
        end
    endtask: run_phase

    task drive();     
        // Once we have the boot and the program code, we can start the processor
        start_cpu();
       
        // And feed the RAM and ROM memories
        fork
            memory_interface(boot); // feed the ROM mem
            memory_interface(req);  // feed the RAM mem
            verify_terminate();     // watch the processor interface to 
        join_any // Complete the fork as soon as the earliest process finish (in this case the verify_terminate is the only one that will terminate!)
        disable fork; //https://stackoverflow.com/questions/14287446/proper-use-of-disable-fork-in-systemverilog
        // Stops the CPU to get another program and start the verification again
        stop_cpu();
    endtask: drive;


    task memory_interface(memory_model memory);
        forever @(riscv_if.memory.mem) begin
            logic [31:0] data_read;
            
            data_read = memory.read_write(riscv_if.memory.mem.address,
                                        riscv_if.memory.mem.data_write,
                                        riscv_if.memory.mem.data_we);
            
            if (!(^data_read === 1'bX)) riscv_if.memory.mem.data_read <= data_read;
        end
    endtask: memory_interface


    task verify_terminate();
        // Waits inside the forever loop, watching the condition to finish the simulation!
        forever @(riscv_if.memory.mem) begin
            if (riscv_if.memory.mem.address == 32'he0000000 && riscv_if.memory.mem.data_we != 4'h0) begin
                riscv_if.memory.mem.data_read <= {32{1'b0}};
                `uvm_info("DRIVER", "FIM DO PROGRAMA", UVM_LOW);
                break;
            end
        end
    endtask: verify_terminate;

    task start_cpu();
        riscv_if.reset = 0;
    endtask: start_cpu;

    task stop_cpu();
        riscv_if.reset = 1;
        #10;
    endtask: stop_cpu;

endclass: driver



`endif
