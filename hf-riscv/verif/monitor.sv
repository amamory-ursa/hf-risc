`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class Monitor_cbs;
  virtual task mem(virtual hfrv_interface.monitor iface, mailbox msgout);
  endtask
endclass

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   Monitor_cbs cbs[$];
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
   endfunction // new

   task run();
      fork;
         watch_mem;
      join;
   endtask // run

   task watch_mem();
      forever @(iface.mem) begin
        foreach (cbs[i]) begin
         cbs[i].mem(this.iface, this.msgout);
        end
      end
   endtask
   
endclass // monitor
`endif
