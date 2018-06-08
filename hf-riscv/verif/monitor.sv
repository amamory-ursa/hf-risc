`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class Monitor_cbs;
  virtual task mem(virtual hfrv_interface.monitor iface, mailbox msgout);
  endtask
endclass

typedef class Termination_monitor;

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   Monitor_cbs cbs[$];
   Termination_monitor termination_monitor;
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
      this.termination_monitor = new(this.terminated);
      this.cbs.push_back(this.termination_monitor);
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

class Termination_monitor extends Monitor_cbs;
  event terminated;

  function new(ref event terminated);
    this.terminated = terminated;
  endfunction

  virtual task mem(virtual hfrv_interface.monitor iface, mailbox msgout);
    if (iface.mem.address == 32'he0000000 && iface.mem.data_we != 4'h0)
    begin
      iface.mem.data_read <= {32{1'b0}};
      ->terminated;
    end
  endtask

endclass
`endif
