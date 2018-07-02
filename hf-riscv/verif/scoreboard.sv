`include "memory.sv"

typedef enum {rw, mw8, mw16, mw32, br} trace_type_t;

typedef struct {
   trace_type_t op;
   int         unsigned addr;
   int         unsigned content;
} tracer_t;

module scoreboard
  (mailbox mem_in,
   mailbox io_in,
   mailbox mem_out,
   mailbox msg_out,
   mailbox tracer_out,
   event terminated);

   import "DPI-C" context function int setup (input int unsigned src[], input int size);
   import "DPI-C" context task void cycle();
   import "DPI-C" context task void dump_sram(output int unsigned dst[], input int size);
   import "DPI-C" context task void set_io(input int pin, input int val);
   
   export "DPI-C" taks terminate;   
   export "DPI-C" task log_branch;
   export "DPI-C" task log_reg;
   export "DPI-C" task log_mwrite32;
   export "DPI-C" task log_mwrite16;
   export "DPI-C" task log_mwrite8;
   export "DPI-C" task log_uart;

   task terminate(int errcode);
      int unsigned mem_dump [0x40000];
      dump_sram(mem_dump, 0x40000);
      mem_out.put(mem_dump);
      
      -> terminated;
   endtask // terminate

   string line = "";

   task log_branch(int unsigned pc);
      tracer_t trace;
      trace.op = br;
      trace.addr = pc;
      tracer_out.put(trace);
   endtask; // log_branch

   task log_reg(byte addr, int unsigned content);
      tracer_t trace;
      trace.op = rw;
      trace.addr = addr;
      trace.content = content;
      tracer_out.put(trace);
   endtask // log_reg

   task log_mwrite32(int unsigned addr, int unsigned content);
      tracer_t trace;
      trace.op = mw32;
      trace.addr = addr;
      trace.content = content;
      tracer_out.put(trace);
   endtask; // log_mwrite32

   task log_mwrite16(int unsigned addr, int unsigned content);
      tracer_t trace;
      trace.op = mw16;
      trace.addr = addr;
      trace.content = content;
      tracer_out.put(trace);
   endtask; // log_mwrite16

   task log_mwrite8(int unsigned addr, int unsigned content);
      tracer_t trace;
      trace.op = mw8;
      trace.addr = addr;
      trace.content = content;
      tracer_out.put(trace);
   endtask; // log_mwrite8

   task log_uart(byte unsigned char);
      if (char != 8'h0A)
        line = {line, char};
      
      if (char == 8'h0A || line.len() == 72) begin
         msg_out.put(line);
         line = "";
      end
   endtask; // log_uart

   task run_loop();
      forever #5
        cycle;
   endtask; // run_loop

   forever begin
      int unsigned mem_dump [0x40000];
      int i;
      memory_model mem;
      mem_in.get(mem);
      
      for (i = 0 ; i < 0x40000 ; i++)
        mem_dump[i] = read_write(mem.base + i, 0, 0);

      setup(mem_dump, 0x100000);
      fork;
         run_loop;
         @terminated;
      join_any;
   end

endmodule; // scoreboard
