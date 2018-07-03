`ifndef SCOREBOARD_SV
 `define SCOREBOARD_SV

 `include "memory.sv"

typedef struct {
   int         cycle;
   int         pc;
   int         pc_next;
   int         opcode;
   int         cause;
   int         mask;
   int         epc;
   int         status;
   int         reg_bank [0:31];
} scoreboard_snapshot_t;

import "DPI-C" context function int setup (input int unsigned src['h40000], input int size, input int debug);
import "DPI-C" context task cycle(output scoreboard_snapshot_t trace);
import "DPI-C" context task dump_sram (output int unsigned dst['h40000], input int size);
import "DPI-C" context task set_io(input int pin, input int val);

export "DPI-C" task log_uart;
export "DPI-C" task terminate;   

mailbox     sb_mem_out;
mailbox     sb_msg_out;
event       sb_terminated;

task log_uart(byte unsigned c);
   static string line = "";
   if (c != 8'h0A)
     line = {line, c};
   
   if (c == 8'h0A || line.len() == 72) begin
      sb_msg_out.put(line);
      line = "";
   end
endtask; // log_uart

task terminate(int errcode);
   static int unsigned mem_dump ['h40000];
   dump_sram(mem_dump, 'h40000);
   sb_mem_out.put(mem_dump);
   $display("Scoreboard terminated with status %d", errcode);
   -> sb_terminated;
endtask // terminate

 `timescale 1ns/1ps

class scoreboard;

   mailbox     io_in;
   mailbox     io_out;
   mailbox     mem_in;
   mailbox     tracer_out;
   int         debug;

   function new
     (mailbox      mem_in,
      mailbox      mem_out,
      mailbox      msg_out,
      mailbox      tracer_out,
      output event terminated,
      input int    debug = 0);
      
      this.mem_in = mem_in;
      sb_mem_out = mem_out;
      sb_msg_out = msg_out;
      this.tracer_out = tracer_out;
      terminated = sb_terminated;
      this.debug = debug;
      
   endfunction;

   task run_loop();
      automatic scoreboard_snapshot_t trace;
      $display("Starting scoreboard run_loop");
      forever #1 begin
         cycle(trace);
         
         if (debug)
           tracer_out.put(trace);
         
         if(sb_terminated.triggered)
           break;
      end
   endtask; // run_loop

   task run();
      forever begin
         static int unsigned mem_dump ['h40000];
         int i;
         memory_model mem;

         $display("Scoreboard waiting for memory");
         
         mem_in.get(mem);

         $display("Scoreboard received memory");
         
         for (i = 0 ; i < mem.length ; i++)
           mem_dump[i] = mem.read_write(mem.base + i, 0, 0);

         $display("Scoreboard dumped memory to vector");
         
         assert(setup(mem_dump, 'h100000, debug));

         $display("Scoreboard setup C code");
         
         run_loop;
      end // forever begin
   endtask; // run
   
endclass // scoreboard

`endif //  `ifndef SCOREBOARD_SV
