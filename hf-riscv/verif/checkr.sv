`ifndef CHECKR_SV
 `define CHECKR_SV

 `include "memory.sv"
 
 `define N_LINES 1048576/32

// place holder checker, needs a proper checker
class checkr;
   mailbox dut_msg;
   mailbox dut_romdump;
   mailbox dut_ramdump;
   mailbox scb2chk;
   
   event end_scb;
   event end_dut;
   event end_chkr;

   function new(mailbox dut_msg, mailbox dut_romdump, mailbox dut_ramdump, mailbox scb2chk, input event end_scb, input event end_dut, input event end_chkr);
      this.dut_msg = dut_msg;
      this.dut_romdump = dut_romdump;
      this.dut_ramdump = dut_ramdump;
      this.scb2chk = scb2chk;
      this.end_scb = end_scb;
      this.end_dut = end_dut;
      this.end_chkr = end_chkr;
   endfunction // new

   task run();
      fork;
         mem_dumper;
         msg_printer;
      join;
   endtask // run

   task mem_dumper();
      automatic memory_model ram;
      automatic memory_model rom;
	  reg [31:0] scb_mem [`N_LINES];
	  int read_data, i, equal; // file descriptor
	  logic [31:0] inst_add, last_add; 

      forever begin
      	
         $display("CHECKER: Start");
         @(end_scb);
         @(end_dut);
         
         $display("CHECKER: Events recived");
         
         dut_ramdump.get(ram);
         dut_romdump.get(rom); 
		 scb2chk.get(scb_mem);
		 $display("Ram dump received");
		 
		   
      inst_add = ram.base;
      last_add = (ram.length/32);
      equal = 0;
      i = 0;
      
      $display("Sc:%d", $size(scb_mem));
      $display("RAM:%d", ram.length);
      
      while(last_add) 
      begin
         read_data = ram.read_write(inst_add,0,0); //reading the RAM
         //$display("%h: %h",inst_add,scb_mem[i]);
         //$display("%h: %h",inst_add,read_data);
         //$display(" ");
         inst_add = inst_add + 4;
         last_add = last_add -1;
                  
         if ((read_data == scb_mem[i]))
         begin
			//$display("equal = %d", equal);
			//equal = equal - 1;
		 end
		 else
		 begin
			  $display("%h: %h",inst_add,scb_mem[i]);
			  $display("%h: %h",inst_add,read_data);
		 end;
		
		 i = i + 1;
         equal = equal + 1;
			
	   end 
		 
		 if (equal == i)
			 begin
				$display("Memories are equals!");
				->end_chkr;
				//$finish();
			 end
		 else
			 begin
				$display("Memories are NOT equals!");
				->end_chkr;
			 end
         
      end      
   endtask // mem_dumper

   task msg_printer();
      automatic string line;
                  
      forever begin
         dut_msg.get(line);
         $display("DUTOUT: %s", line);
      end   
   endtask // print_msg

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
