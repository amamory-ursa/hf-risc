`ifndef AGENT_SV
 `define AGENT_SV

 `include "memory.sv"
 `include "platform_driver.sv"

class agent;

	 mailbox gen2agt;
	 mailbox agt2rom;
	 mailbox agt2ram;
	 mailbox agt2drv;
	 event 	 dumpmem;
   event   terminated;
   stop_cpu stop;
   start_cpu start;
   
   
	 function new (mailbox gen2agt, mailbox agt2rom, mailbox agt2ram, mailbox agt2drv,
								 event dumpmem, event terminated);
			this.gen2agt = gen2agt;
			this.agt2ram = agt2ram;
			this.agt2rom = agt2rom;
			this.agt2drv = agt2drv;
			this.dumpmem = dumpmem;
			this.terminated = terminated;
			start = new();
			stop = new();
	 endfunction // new

	 task run();
			forever begin
				 automatic memory_model trans;
				 gen2agt.get(trans);
				 feed_dut(trans);
				 @(terminated);
				 halt_dut();
			end
	 endtask // run

	 task feed_dut(memory_model trans);
			logic [31:0] boot_rom [$];
			$readmemh("boot.txt", boot_rom);
			memory_model boot = new(boot_rom, h0, h100000);
			agt2ram.put(trans);
			agt2rom.put(boot);
			agt2drv.put(start);
	 endtask // feed_cpu

	 task halt_dut();
			agt2drv.put(stop);
			->dumpram;			
	 endtask // halt_dut
	 
	 
endclass // agent		

`endif
