`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"

class Monitor_cbs;
  virtual task uart(virtual hfrv_interface.monitor iface);
  endtask

  virtual task time_step(int timecounter,
                         ref Timemachine timemachine);
  endtask

  virtual task terminated();
  endtask
endclass

typedef class Fake_uart;

class monitor;
   virtual hfrv_interface.monitor iface;
   event   terminated;
   Monitor_cbs cbs[$];
   Timemachine timemachine;
   Fake_uart fake_uart;
   mailbox msgout;

   function new(virtual hfrv_interface.monitor iface, input event terminated, mailbox msgout);
      this.iface = iface;
      this.terminated = terminated;
      this.msgout = msgout;
      this.fake_uart = new(this);
      this.cbs.push_back(this.fake_uart);
   endfunction // new

   task run();
      timemachine = new;
      forever @(iface.mem) begin
        if(iface.mem.address == 32'hf00000d0) begin
          foreach (cbs[i]) begin
           cbs[i].uart(this.iface);
          end
        end
        else
        if (iface.mem.address == 32'he0000000 && iface.mem.data_we != 4'h0)
        begin
          iface.mem.data_read <= {32{1'b0}};
          ->terminated;
          foreach (cbs[i]) begin
            cbs[i].terminated();
          end
          $finish;
        end
        else
        begin
          automatic Snapshot snap;
          automatic int timecounter;
          snap.data_access = tb_top.dut.cpu.data_access;
          snap.address = iface.mem.address;
          snap.data_read = iface.mem.data_read;
          snap.data_we = iface.mem.data_we;
          foreach (snap.registers[i]) begin
            snap.registers[i] = tb_top.dut.cpu.register_bank.registers[i];
          end
          this.timemachine.snapshot.push_back(snap);
          timecounter = timemachine.snapshot.size()-1;
          $display("test: %d, %d", timecounter, timemachine.isInstruction(timecounter));
          foreach (cbs[i]) begin
            cbs[i].time_step(timecounter, timemachine);
          end
        end
      end
   endtask

endclass // monitor

class Fake_uart extends Monitor_cbs;
  string line;
  monitor mon;
  byte char;

  function new(monitor mon);
    this.line = "";
    this.mon = mon;
  endfunction

  virtual task uart(virtual hfrv_interface.monitor iface);
    super.uart(iface);
    char = iface.mem.data_write[30:24];
    iface.mem.data_read <= {32{1'b0}};
    if (char != 8'h0A)
     line = {line, char};

    if (char == 8'h0A || line.len() >= 72) begin
      mon.msgout.put(line);
      line = "";
    end
  endtask
endclass

`endif
