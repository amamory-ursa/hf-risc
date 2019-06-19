import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dut_top.sv"
`include "test_top.sv"

`timescale 1ns/1ns

module top_uvm;

    logic rst, clk;


    initial begin
		rst = 0; clk = 0;
		#5ns rst = 1;
		#5ns clk = 1;
		#5ns rst = 0; clk = 0;
		forever #5ns clk = ~clk;
	end

    hfrv_interface riscv_if(clk); // Interface
    dut_top riscv(riscv_if);      // DUT

    initial begin
        uvm_config_db#(virtual hfrv_interface)::set(null, "*", "riscv_if", riscv_if);

        uvm_config_db#(virtual hfrv_interface)::set(null, "uvm_test_top.env.agt.drv", "riscv_if", riscv_if);

        $dumpfile("dump.vcd"); $dumpvars;

        run_test();
    end

endmodule: top_uvm
