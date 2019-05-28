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
 `include "gpio.sv"


class environment;
   virtual hfrv_interface iface;
   mailbox gen2agt;
   mailbox agt2rom;
   mailbox agt2ram;
   mailbox agt2drv;
   mailbox ramdump;
   mailbox romdump;
   mailbox dut_msg;
   mailbox agt2scb; // Comunication between agent and scoreboard modules
   mailbox scb2chk; // Comunication between scoreboard and checker modules
   
   event   dump_memory;
   event   dut_terminated;
   event   start_scb; // Event to start scoreboard
   event   end_scb; // Event to finish scoreboard
   event   end_chkr; // Event to finish scoreboard

   mailbox io_gen2driv;
   mailbox io_gen2scb;
   mailbox io_driv2ckr;
   mailbox io_mon2ckr;

   platform_driver drv;
   memory_driver   ram;
   memory_driver   rom;
   generator       gen;
   monitor         mon;
   agent           agt;
   checkr          chk;
   scoreboard      scb;
  
   gpio_gen        iog;
   gpio_drv        iod;
   gpio_monitor    iom;

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

      io_gen2driv = new();
      io_gen2scb = new();
      io_driv2ckr = new();
      io_mon2ckr = new();
      
      
      gen = new(gen2agt, dut_terminated, end_chkr);
      ram = new(iface, agt2ram, ramdump, dump_memory);
      rom = new(iface, agt2rom, romdump, dump_memory);
      drv = new(iface, agt2drv);
      mon = new(iface, dut_terminated, dut_msg);
      chk = new(dut_msg, romdump, ramdump, scb2chk, end_scb, dut_terminated, end_chkr, io_driv2ckr, io_mon2ckr);
      scb = new(agt2scb, scb2chk, io_gen2scb, start_scb, end_scb);    
      agt = new(gen2agt, agt2rom, agt2ram, agt2drv, agt2scb, dump_memory, dut_terminated, start_scb);

      iog = new(io_gen2driv, io_gen2scb);
      iod = new(iface, io_gen2driv, io_driv2ckr);
      iom = new(iface, io_mon2ckr);
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
         iog.run;
         iod.run;
         iom.run;
      join;
   endtask // run
   
endclass // environment

`endif
