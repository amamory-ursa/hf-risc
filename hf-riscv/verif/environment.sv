`ifndef ENVIRONMENT_SV
 `define ENVIRONMENT_SV

 `include "hfrv_interface.sv"
 `include "generator.sv"
 `include "agent.sv"
 `include "memory.sv"
 `include "platform_driver.sv"
 `include "monitor.sv"
 `include "checkr.sv"
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
   event   dump_memory;
   event   dut_terminated;

   mailbox io_gen2driv;
   mailbox io_driv2ckr;
   mailbox io_mon2ckr;

   platform_driver drv;
   memory_driver   ram;
   memory_driver   rom;
   generator       gen;
   monitor         mon;
   agent           agt;
   checkr          chk;

   gpio_gen        iog;
   gpio_drv        iod;
   gpio_monitor    iom;

   function new (virtual hfrv_interface iface);
      this.iface = iface;
      gen2agt = new();
      agt2rom = new();
      agt2ram = new();
      agt2drv = new();
      ramdump = new();
      romdump = new();
      dut_msg = new();

      io_gen2driv = new();
      io_driv2ckr = new();
      io_mon2ckr = new();
      
      
      gen = new(gen2agt, dut_terminated);
      ram = new(iface, agt2ram, ramdump, dump_memory);
      rom = new(iface, agt2rom, romdump, dump_memory);
      drv = new(iface, agt2drv);
      mon = new(iface, dut_terminated, dut_msg);
      chk = new(dut_msg, romdump, ramdump, io_driv2ckr, io_mon2ckr);
      agt = new(gen2agt, agt2rom, agt2ram, agt2drv, dump_memory, dut_terminated);


      iog = new(io_gen2driv);
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

         iog.run;
         iod.run;
         iom.run;
      join;
   endtask // run
   
endclass // environment

`endif
