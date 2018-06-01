`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
   endfunction // new

   task run();
      fork;
         fake_uart;
		 debug_process;
         termination_monitor; 
      join;
   endtask // run

   task fake_uart();
      string line = "";
      forever @(iface.mem)
        if(iface.mem.address == 32'hf00000d0) begin
           automatic byte char = iface.mem.data_write[30:24];
           iface.mem.data_read <= {32{1'b0}};       
           if (char != 8'h0A)
             line = {line, char};
           
           if (char == 8'h0A || line.len() == 72) begin
              msgout.put(line);
              line = "";
           end
        end
   endtask // fake_uart
   
	// Debug process
	task debug_process();
	integer f, line_length;
	f = $fopen("sv_debug.txt","w");		
	forever  @(iface.mem)		
		if (iface.mem.address == 32'hf00000d0)
		begin			
			$fwrite(f,"%c",iface.mem.data_write[30:24]);
			if (iface.mem.data_write[30:24] == 10)
				line_length = 0;
			else
				line_length = line_length + 1;		
		end	
		
		else if (line_length >= 72)
		begin
			$fwrite(f,"\n");
			$fwrite(f,"%c",iface.mem.data_write[30:24]);	
			line_length = 0;		
		end
	endtask
	//Debug process

   task termination_monitor();
      forever @(iface.mem)
        if (iface.mem.address == 32'he0000000 && iface.mem.data_we != 4'h0) begin
			//$display("MONITOR: address == %h",iface.mem.address);            
			iface.mem.data_read <= {32{1'b0}};
			//$display("MONITOR: sending event");           
			->terminated;
        	//$display("MONITOR: event sended");
        end
   endtask; // termination_monitor
   
endclass // monitor
`endif
