`ifndef ENVIRONMENT_SV
 `define ENVIRONMENT_SV

 `include "hfrv_interface.sv"
 `include "generator.sv"
 `include "agent.sv"
 `include "memory.sv"
 `include "platform_driver.sv"
 `include "monitor.sv"
 `include "checkr.sv"

class environment;
   virtual hfrv_interface iface;
   mailbox gen2agent;
   mailbox gen2rom;
   mailbox gen2ram;
   mailbox gen2drv;
   mailbox ramdump;
   mailbox romdump;
   mailbox dut_msg;
   event   dump_memory;
   event   dut_terminated;

   platform_driver drv;
   memory_driver   ram;
   memory_driver   rom;
   generator       gen;
   monitor         mon;
   agent           agt;
   checkr          chk;

   function new (virtual hfrv_interface iface);
      this.iface = iface;
      gen2agent = new();
      gen2rom = new();
      gen2ram = new();
      gen2drv = new();
      ramdump = new();
      romdump = new();
      dut_msg = new();
      gen = new(gen2agent, dut_terminated);
      ram = new(iface, gen2ram, ramdump, dump_memory);
      rom = new(iface, gen2rom, romdump, dump_memory);
      drv = new(iface, gen2drv);
      mon = new(iface, dut_terminated, dut_msg);
      chk = new(dut_msg, romdump, ramdump);
   endfunction // new

   task run();
      fork;
         gen.run;
         ram.run;
         rom.run;
         drv.run;
         mon.run;
         chk.run;
      join;
   endtask // run
   
endclass // environment

`endif
