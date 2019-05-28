`ifndef AGENT_SV
 `define AGENT_SV

 `include "memory.sv"
 `include "platform_driver.sv"

class agent;

   mailbox gen2agt;
   mailbox agt2rom;
   mailbox agt2ram;
   mailbox agt2drv;
   mailbox agt2scb;
   
   event   dumpmem;
   event   terminated;
   event   start_scb;
   
   stop_cpu stop;
   start_cpu start;
   
   function new (mailbox gen2agt, mailbox agt2rom, mailbox agt2ram, mailbox agt2drv, mailbox agt2scb,
                 input event dumpmem, input event terminated, input event start_scb);
      this.gen2agt = gen2agt;
      this.agt2ram = agt2ram;
      this.agt2rom = agt2rom;
      this.agt2drv = agt2drv;
      this.agt2scb = agt2scb;
      
      this.dumpmem = dumpmem;
      this.terminated = terminated;
      this.start_scb = start_scb;
      start = new();
      stop = new();
   endfunction // new

   task run();
      forever begin
         automatic memory_model trans;
         gen2agt.get(trans);
         agt2scb.put(trans);
         ->start_scb;
         feed_dut(trans);
         @(terminated);
         halt_dut();
      end
   endtask // run

   task feed_dut(memory_model trans);
      memory_model boot;
      boot = new("boot.txt", 'h0, 'h100000);
      agt2ram.put(trans);
      agt2rom.put(boot);
      agt2drv.put(start);
   endtask // feed_cpu

   task halt_dut();
      agt2drv.put(stop);
      ->dumpmem;   
   endtask // halt_dut
   
   
endclass // agent   

`endif
