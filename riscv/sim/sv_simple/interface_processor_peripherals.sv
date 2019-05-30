
`timescale 1ns/1ns

interface interface_processor_peripherals (input bit clock_in);

  //variable declarations
  /*logic reset, stall, stall_cpu, irq_cpu, irq_ack_cpu, exception_cpu, data_access_cpu;
  logic[31:0] irq_vector_cpu, address_cpu, data_in_cpu, data_out_cpu;
  logic[3:0] data_w_cpu;*/

  logic reset, stall_sig;
  logic[31:0] address, data_read, data_write;
  logic[3:0] data_we;
  logic[7:0] ext_irq, ext_orq;

endinterface
