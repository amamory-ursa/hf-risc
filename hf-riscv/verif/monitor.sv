`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class Monitor_cbs;
  virtual task mem(virtual hfrv_interface.monitor iface);
  endtask
endclass

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   Monitor_cbs cbsq[$];
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
   endfunction // new

   task run();
      fork;
         watch_mem;
         debug_process;
         termination_monitor; 
      join;
   endtask // run

   task watch_mem();
      forever @(iface.mem) begin
        foreach (cbsq[i])
         cbsq[i].mem(this.iface);
        end
      end
   endtask
   
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
