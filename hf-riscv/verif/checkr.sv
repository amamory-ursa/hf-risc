`ifndef CHECKR_SV
 `define CHECKR_SV

 `include "memory.sv"

// place holder checker, needs a proper checker
class checkr;
   mailbox dut_msg;
   mailbox dut_romdump;
   mailbox dut_ramdump;

   function new(mailbox dut_msg, mailbox dut_romdump, mailbox dut_ramdump);
      this.dut_msg = dut_msg;
      this.dut_romdump = dut_romdump;
      this.dut_ramdump = dut_ramdump;
   endfunction // new

   task run();
      fork;
         mem_dumper;
         msg_printer;
      join;
   endtask // run

   task mem_dumper();
      automatic var memory ram;
      automatic var memory rom;

      forever begin
         dut_ramdump.get(ram);
         dut_romdump.get(rom);
         
         read_ram(ram);
         read_ram(rom);
      end      
   endtask // mem_dumper

   task msg_printer();
      automatic string line;
      
      forever begin
         dut_msg.get(line);
         $display("DUTOUT: %s", line);
      end   
   endtask // print_msg

   task read_ram(memory ram);
      int read_data; // file descriptor
      logic [31:0] inst_add, last_add;    
      inst_add = ram.base;
      last_add = ram.base + ram.length;
      while(inst_add < last_add) begin
         read_data = ram.read_write(inst_add,0,0); //reading the RAM
         inst_add = inst_add + 1;
         $display("%h: %h",inst_add,read_data);
      end 
   endtask : read_ram
   
endclass // checkr

`endif
