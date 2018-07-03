`ifndef MONITOR_SV
 `define MONITOR_SV

 `include "hfrv_interface.sv"
 `include "gpio.sv"

class Monitor_cbs;
  virtual task uart(virtual hfrv_interface.monitor iface);
  endtask

  // called at each clock step.
  //   t=timecounter (current step)
  //   timemachine is a ref to an instance of Timemachine (timemachine.sv)
  //   timemachine has a queue (expandable array) of snaphots (snapshot.sv)
  virtual task time_step(int t, ref Timemachine timemachine);
  endtask

  // called when execution of code.txt ends
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
          foreach (cbs[i]) begin
            cbs[i].terminated();
          end
          ->terminated;
        end
        else
        begin
          int timecounter;
          register [0:31] registers;
          foreach (registers[i]) begin // copies register bank
            registers[i] = tb_top.dut.cpu.register_bank.registers[i];
          end
          // timemachine.step fills a new instance of snaphot and adds it to the snaphots queue
          timecounter = timemachine.step(tb_top.dut.cpu.data_access, // flag -> load, store
                                         tb_top.dut.cpu.data_in,     // 32 bit instr
                                         tb_top.dut.cpu.pc_last2,    // pc (last2 should match current pipeline phase)
                                         registers);                 // array of 32 registers, 32 bit each
          foreach (cbs[i]) begin // call callbacks that use snapshots, like assertions callbacks
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

class gpio_monitor;
  virtual hfrv_interface.gpio iface;
  mailbox mon2ckr;
  gpio_trans trans;

  function new(virtual hfrv_interface.gpio iface, mailbox mon2ckr);
    this.iface = iface;
    this.mon2ckr = mon2ckr;
  endfunction // new

  task run();
    forever @(iface.extio_out)
    begin
      trans = new;
      trans.value = iface.extio_out;
      trans.t_time = $time;
      trans.d = out;
      mon2ckr.put(trans);
    end
  endtask
endclass

`endif
