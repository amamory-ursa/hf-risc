`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class Monitor_cbs;
  virtual task mem(virtual hfrv_interface.monitor iface);
  endtask
  virtual task data_access();
  endtask
  virtual task terminated();
  endtask
endclass

typedef class Termination_monitor;
typedef class Fake_uart;

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   Monitor_cbs cbs[$];
   Termination_monitor termination_monitor;
   Fake_uart fake_uart;
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
      this.termination_monitor = new(this.terminated);
      this.fake_uart = new(msgout);
      this.cbs.push_back(this.termination_monitor);
      this.cbs.push_back(this.fake_uart);
   endfunction // new

   task run();
      fork;
         watch_mem;
         watch_terminated;
         watch_data_access;
      join;
   endtask // run

   task watch_data_access();
      forever @(posedge iface.mem.data_access) begin
        foreach (cbs[i]) begin
         cbs[i].data_access();
        end
      end
   endtask

   task watch_mem();
      forever @(iface.mem) begin
        foreach (cbs[i]) begin
         cbs[i].mem(this.iface);
        end
      end
   endtask

   task watch_terminated();
     @(terminated) begin
       foreach (cbs[i]) begin
        cbs[i].terminated();
       end
       $finish;
     end
   endtask

endclass // monitor

class Termination_monitor extends Monitor_cbs;
  event terminated;

  function new(ref event terminated);
    this.terminated = terminated;
  endfunction

  virtual task mem(virtual hfrv_interface.monitor iface);
    if (iface.mem.address == 32'he0000000 && iface.mem.data_we != 4'h0)
    begin
      iface.mem.data_read <= {32{1'b0}};
      ->terminated;
    end
  endtask

endclass

class Fake_uart extends Monitor_cbs;
  string line;
  mailbox msgout;

  function new(mailbox msgout);
    this.line = "";
    this.msgout = msgout;
  endfunction

  virtual task mem(virtual hfrv_interface.monitor iface);
    if(iface.mem.address == 32'hf00000d0) begin
       automatic byte char = iface.mem.data_write[30:24];
       iface.mem.data_read <= {32{1'b0}};
       if (char != 8'h0A)
         line = {line, char};

       if (char == 8'h0A || line.len() == 72) begin
          this.msgout.put(line);
          line = "";
       end
    end
  endtask
endclass

`endif
