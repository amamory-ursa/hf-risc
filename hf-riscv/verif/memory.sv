`ifndef MEMORY_SV
 `define MEMORY_SV

 `include "hfrv_interface.sv"

class memory_model;
	 logic [31:0] data[$];
	 logic [31:0] base;
	 logic [31:0] length;

	 function new(logic [31:0] data[$], logic [31:0] base, logic [31:0] length);
			this.data = data;
			this.base = base;
			this.length = length;
	 endfunction; // new
	 
	 function logic [31:0] read_write
		 (logic [31:0] address,
			logic [31:0] w_data,
			logic [3:0]  we);
			
			logic [31:0] read_data;
			integer 		 offset = address - base;
			logic [31:0] mask = {8{we[3]},8{we[2]},8{we{1}},8{we[0]}};
			
			if (offset > 0 && offset < length) begin
				 read_data = data[offset];
				 data[offset] = (read_data & ~mask) | (w_data & mask);
			end else
				read_data = {32{1'bz}};
			
			return read_data;
	 endfunction // read_write
	 
endclass; // memory_model

class memory_driver;
	 memory_model memory;
	 mailbox gen2mem;
	 mailbox mem2mon;
	 hfrv_interface.memory iface;

	 function new(hfrv_interface.memory iface, mailbox gen2mem, mailbox mem2mon);
			this.iface = iface;
			this.gen2mem = gen2mem;
			this.mem2mon = mem2mon;
	 endfunction; // new
	 
	 task run();
			automatic memory new_memory;
			gen2mem.get(memory);
			forever begin
				 fork: memory_server;
						forever @(iface.mem) begin
							 iface.mem.data_read <= memory.read_write(iface.mem.addres,
																												iface.mem.data_write,
																												iface.mem.data_we);
						end
						begin
							 gen2mem.get(new_memory);
							 mem2mon.put(memory);
							 memory = new_memory;
						end
				 join_any;
				 disable memory_server;
			end
	 endtask; // run
endclass; // memory_driver

`endif
