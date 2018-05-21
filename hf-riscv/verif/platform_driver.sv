`ifndef PLATFORM_DRIVER_SV
 `define PLATFORM_DRIVER_SV

 `include "hfrv_interface.sv"

typedef class platform_driver;

virtual class platform_transaction;
	 pure virtual task run(platform_driver cb);
endclass // platform_transaction

class platform_driver;
	 virtual hfrv_interface.driver iface;
	 event 	 program_finished;
	 mailbox gen2drv;

	 function new
		 (virtual hfrv_interface.driver iface,
			event 	program_finished,
			mailbox gen2drv);
			
			this.iface = iface;
			this.program_finished = program_finished;
			this.gen2drv = gen2drv;
	 endfunction; // new

	 task run();
			automatic platform_transaction cmd;
			iface.reset = 1;
			iface.stall = 0;
			fork:
				 forever @(iface.mem)
					 if (iface.mem.address = 32'he0000000 && iface.mem.we != 4'h0)
						 ->program_finished;
				 forever begin
						gen2drv.get(cmd);
						cmd.run(this);
				 end
			join;
			
	 endtask; // run
	 
endclass; // platform_driver

class start_cpu extends platform_transaction;
	 virtual task run(platform_driver cb);
			cb.iface.reset <= 1'b0;
	 endtask; // run
endclass // start_cpu

class stop_cpu extends platform_transaction;
	 virtual task run(platform_driver cb);
			cb.iface.reset <= 1'b1;
	 endtask; // run
endclass // stop_cpu
	 
`endif
