`ifndef GENERATOR_SV
 `define GENERATOR_SV

 `include "memory.sv"

class generator;

   memory_model ram;    
   mailbox    gen2agent;  // Mailbox to driver for cells
   event      terminated;  // Event from monitor when terminated program execution
   
   function new(input mailbox gen2agent,
                input event terminated);
      this.gen2agent = gen2agent;
      this.terminated = terminated;
      ram = new({}, 32'h40000000, 'h100000);
   endfunction : new

   task run();
      forever begin
         write_ram();
         gen2agent.put(ram);
         @(terminated);
         ram = new({}, 32'h40000000, 'h100000);
      end
   endtask // run

   task write_ram();
      int code, i, r; // file descriptor
      int instruction, write_data;
      logic [31:0] inst_add;
      code = $fopen("code.txt","r");  
      inst_add = 'h40000000;
      while(! $feof(code)) begin
         r = $fscanf(code,"%h\n",instruction);
         write_data = ram.read_write(inst_add,instruction,'hF); //writing in the RAM
         inst_add = inst_add + 4;
      end
      $fclose(code);
   endtask : write_ram

endclass : generator

`endif
