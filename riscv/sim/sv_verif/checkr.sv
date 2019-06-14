`ifndef CHECKR_SV
 `define CHECKR_SV

 `include "memory.sv"
 
 `define N_LINES 1048576/32
 `define N_IO 512

 `include "gpio.sv"

// place holder checker, needs a proper checker
class checkr;
   mailbox dut_msg;
   mailbox dut_romdump;
   mailbox dut_ramdump;
   mailbox scb2chk;
   mailbox io_input;
   mailbox io_output;
   
   event end_scb;
   event end_dut;
   event end_chkr;

   function new(mailbox dut_msg, mailbox dut_romdump, mailbox dut_ramdump, mailbox scb2chk, input event end_scb, input event end_dut, input event end_chkr, mailbox io_input, mailbox io_output);
      this.dut_msg = dut_msg;
      this.dut_romdump = dut_romdump;
      this.dut_ramdump = dut_ramdump;
      this.scb2chk = scb2chk;
      this.end_scb = end_scb;
      this.end_dut = end_dut;
      this.end_chkr = end_chkr;
      this.io_input = io_input;
      this.io_output = io_output;
   endfunction // new

   task run();

      fork;
         mem_dumper;
         msg_printer;
         //output_printer;
      join;
   endtask // run

   // Task used to compare the scoreboard memory and the DUT memory
   task mem_dumper();
      automatic memory_model ram;
      automatic memory_model rom;
      reg [31:0] scb_mem [`N_LINES];
      bit [31:0] scb_io [`N_IO];
      int read_data, i, equal; // file descriptor
      logic [31:0] inst_add, last_add;
      gpio_trans trans;
      int num_io, io_err;

      begin
      	
         @(end_scb);
         $display("CHECKER received the end signal from the scoreboard!");
         @(end_dut);
         $display("CHECKER received the end signal from the DUT!");

         dut_ramdump.get(ram);
         dut_romdump.get(rom); 
         scb2chk.get(scb_mem);
         scb2chk.get(scb_io);
         $display("CHECKER got the generated data! checking ...");
		   
         inst_add = ram.base;
         last_add = (ram.length/32);
         equal = 0;
         i = 0;
            
         while(last_add) 
         begin
            read_data = ram.read_write(inst_add,0,0); //reading the RAM
            inst_add = inst_add + 4;
            last_add = last_add -1;
                     
            // Comparison word by word of scoreboard and DUT memories
            if ((read_data == scb_mem[i]))
            begin
      			equal = equal + 1;
      		end
            else
      		begin
      			$display("%h: %h",inst_add,scb_mem[i]);
      			$display("%h: %h",inst_add,read_data);
      		end;
   		
            i = i + 1;
   			
   	   end

   		if (equal == i)
   			$display("Memories are equals!");
   		else
   			$display("Memories are NOT equals!");


         i = 0;
         io_output.try_get(trans);
         io_err = 0;
         while (io_output.try_get(trans)) begin
            if (scb_io[i*2] != trans.value) begin
               $display("GPIO: Value = %h, time = %10d, Direction = %s", trans.value, trans.t_time, trans.d);
               $display("SCB: Value = %h, time = %10d", scb_io[i*2], scb_io[i*2+1]);
               io_err++;
            end
            i++;
         end

         $display("IO verification errors: %d", io_err);


         //if (io_output.try_get(trans)) begin
            /*io_output.get(trans);
            num_io = trans.value;
            for (i = 0; i < num_io; i++) begin
               //if (scb_io[i*2] == trans.value)
               $display("transaction value = %d, scoreboard value = %d", trans.value, scb_io[i*2]);
               $display("transaction time = %d, scoreboard time = %d", trans.t_time, scb_io[i*2+1]);
               io_output.get(trans);
            end*/
         //end
         ->end_chkr;
      end
   endtask // mem_dumper

   task msg_printer();
      automatic string line;
                  
      forever begin
         dut_msg.get(line);
         $display("DUTOUT: %s", line);
      end   
   endtask // print_msg

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
