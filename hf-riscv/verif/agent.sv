`ifndef AGENT_SV
 `define AGENT_SV

 `include "memory.sv"
 `include "platform_driver.sv"

class agent;

   mailbox gen2agt;
   mailbox agt2rom;
   mailbox agt2ram;
   mailbox agt2drv;
   mailbox agt2sb;
   event   dumpmem;
   event   terminated;
   
   stop_cpu stop;
   start_cpu start;
   
   function new
     (mailbox     gen2agt,
      mailbox     agt2rom,
      mailbox     agt2ram,
      mailbox     agt2drv,
      mailbox     agt2sb,
      input event dumpmem,
      input event terminated);

      this.agt2sb = agt2sb;
      this.gen2agt = gen2agt;
      this.agt2ram = agt2ram;
      this.agt2rom = agt2rom;
      this.agt2drv = agt2drv;
      this.dumpmem = dumpmem;
      this.terminated = terminated;
      start = new();
      stop = new();
   endfunction // new

   task run();
      forever begin
         automatic memory_model trans;
         gen2agt.get(trans);
         $display("program received");
         feed_dut(trans);
         // feed scoreboard
         agt2sb.put(trans);
         //$display("AGENT: waiting event");
         @(terminated);
         //$display("AGENT: event received");
         halt_dut();
      end
   endtask // run

   task feed_dut(memory_model trans);
      memory_model boot;
      $display("loading boot.txt");
      boot = new("boot.txt", 'h0, 'h100000);
      $display("sending program to ram");
      agt2ram.put(trans);
      $display("sending bootloader to rom");
      agt2rom.put(boot);
      $display("sending start command to platform driver");
      agt2drv.put(start);
   endtask // feed_cpu

   task halt_dut();
      agt2drv.put(stop);
      -> dumpmem; 
   endtask // halt_dut
   
   
endclass // agent   

`endif
