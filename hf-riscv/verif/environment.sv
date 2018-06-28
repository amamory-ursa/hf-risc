`ifndef ENVIRONMENT_SV
 `define ENVIRONMENT_SV

 `include "hfrv_interface.sv"
 `include "generator.sv"
 `include "agent.sv"
 `include "memory.sv"
 `include "platform_driver.sv"
 `include "monitor.sv"
 `include "checkr.sv"
 `include "scoreboard.sv"

class environment;
   virtual hfrv_interface iface;
   mailbox gen2agt;
   mailbox agt2rom;
   mailbox agt2ram;
   mailbox agt2drv;
   mailbox ramdump;
   mailbox romdump;
   mailbox dut_msg;
   mailbox agt2scb;
   mailbox scb2chk;
   
   event   dump_memory;
   event   dut_terminated;
   event   start_scb;
   event   end_scb;
   event   end_chkr;

   platform_driver drv;
   memory_driver   ram;
   memory_driver   rom;
   generator       gen;
   monitor         mon;
   agent           agt;
   checkr          chk;
   scoreboard      scb;
  
   function new (virtual hfrv_interface iface);
      this.iface = iface;
      gen2agt = new();
      agt2rom = new();
      agt2ram = new();
      agt2drv = new();
      agt2scb = new();
      ramdump = new();
      romdump = new();
      dut_msg = new();
      scb2chk = new();
      gen = new(gen2agt, dut_terminated, end_chkr);
      ram = new(iface, agt2ram, ramdump, dump_memory);
      rom = new(iface, agt2rom, romdump, dump_memory);
      drv = new(iface, agt2drv);
      mon = new(iface, dut_terminated, dut_msg);
      chk = new(dut_msg, romdump, ramdump, scb2chk, end_scb, dut_terminated, end_chkr);
      agt = new(gen2agt, agt2rom, agt2ram, agt2drv, agt2scb, dump_memory, dut_terminated, start_scb);
      scb = new(agt2scb,scb2chk,start_scb,end_scb);
   endfunction // new

   task run();
      fork;
         gen.run;
         agt.run;
         ram.run;
         rom.run;
         drv.run;
         mon.run;
         chk.run;
         scb.run_scoreboard;
      join;
   endtask // run
   
endclass // environment

`endif
