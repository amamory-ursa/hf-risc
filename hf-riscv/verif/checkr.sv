`ifndef CHECKR_SV
 `define CHECKR_SV

 `include "memory.sv"
 `include "gpio.sv"
// place holder checker, needs a proper checker
class checkr;
   mailbox dut_msg;
   mailbox dut_romdump;
   mailbox dut_ramdump;

   mailbox io_input;
   mailbox io_output;

   function new(mailbox dut_msg, mailbox dut_romdump, mailbox dut_ramdump, mailbox io_input, mailbox io_output);
      this.dut_msg = dut_msg;
      this.dut_romdump = dut_romdump;
      this.dut_ramdump = dut_ramdump;
      this.io_input = io_input;
      this.io_output = io_output;
   endfunction // new

   task run();
	  //$display("CHECKER: start");
      fork;
         mem_dumper;
         msg_printer;
         input_printer;
         output_printer;
      join;
   endtask // run

   task mem_dumper();
      automatic memory_model ram;
      automatic memory_model rom;

      forever begin
         dut_ramdump.get(ram);
         dut_romdump.get(rom);

         $display("Ram dump received");
      end      
   endtask // mem_dumper

   task msg_printer();
      automatic string line;
      
      forever begin
         dut_msg.get(line);
         //$display("DUTOUT: %s", line);
      end   
   endtask // print_msg

   task input_printer();
      gpio_trans trans;
      forever begin
         io_input.get(trans);
         $display("GPIO: Value = %h, time = %10d, Direction = %s", trans.value, trans.t_time, trans.d);
      end  
   endtask

   task output_printer();
      gpio_trans trans;
      forever begin
         io_output.get(trans);
         $display("GPIO: Value = %h, time = %10d, Direction = %s", trans.value, trans.t_time, trans.d);
      end  
   endtask

   task read_ram(memory_model ram);
      int read_data; // file descriptor
      logic [31:0] inst_add, last_add;    
      inst_add = ram.base;
      last_add = ram.base + ram.length;
      while(inst_add < last_add) begin
         read_data = ram.read_write(inst_add,0,0); //reading the RAM
         inst_add = inst_add + 4;
         $display("%h: %h",inst_add,read_data);
      end 
   endtask : read_ram
   
endclass // checkr

`endif
