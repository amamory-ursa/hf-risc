`ifndef CHECKR_SV
 `define CHECKR_SV

 `include "memory.sv"
 `include "gpio.sv"

class checkr;
   mailbox dut_msg;
   mailbox dut_romdump;
   mailbox dut_ramdump;

   mailbox io_input;
   mailbox io_output;

   mailbox sb_msg;
   mailbox sb_ramdump;
   mailbox sb_trace;

   function new
     (mailbox dut_msg,
      mailbox dut_romdump,
      mailbox dut_ramdump,
      mailbox io_input,
      mailbox io_output,
      mailbox sb_msg,
      mailbox sb_ramdump,
      mailbox sb_trace);
      
      this.dut_msg = dut_msg;
      this.dut_romdump = dut_romdump;
      this.dut_ramdump = dut_ramdump;
      this.io_input = io_input;
      this.io_output = io_output;
      this.sb_msg = sb_msg;
      this.sb_ramdump = sb_ramdump;
      this.sb_trace;
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
      automatic memory_model dut_ram;
      automatic memory_model dut_rom;
      static int unsigned sb_ram ['h40000];

      automatic int unsigned addr;
      automatic int unsigned dut_data;
      automatic int unsigned sb_data;
      forever begin
         dut_romdump.get(dut_rom);
         dut_ramdump.get(dut_ram);
         sb_ramdump.get(sb_ram);
         $display("Ram dump received");
         for (int i = 0 ; i < 'h40000 ; i++) begin
            addr = dut_ram.base + i;
            dut_data = dut_ram.read_write(addr, 32'h0, 4'h0);
            sb_data = sb_ram[i];
            
            if(dut_data != sb_data)
              $display("Memory mismatch at %x: DUT(%x), SB(%x)", addr, dut_data, sb_data);
         end
         
      end      
   endtask // mem_dumper

   task msg_printer();
      automatic string dut_line;
      automatic string sb_line;

      fork
         forever begin
            dut_msg.get(dut_line);
            $display("DUTOUT: %s", dut_line);
         end
         forever begin
            dut_msg.get(sb_line);
            $display("SBOUT: %s", sb_line);
         end
      join;
      
   endtask // print_msg

   task input_printer();
      gpio_trans trans;
      forever begin
         io_input.get(trans);
         //$display("GPIO: Value = %h, time = %10d, Direction = %s", trans.value, trans.t_time, trans.d);
      end  
   endtask

   task output_printer();
      gpio_trans trans;
      forever begin
         io_output.get(trans);
         //$display("GPIO: Value = %h, time = %10d, Direction = %s", trans.value, trans.t_time, trans.d);
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
