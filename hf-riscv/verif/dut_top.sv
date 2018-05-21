`ifndef DUT_TOP_SV
 `define DUT_TOP_SV

`include "hfrv_interface.sv"

module dut_top (cpu_interface.cpu iface);

	 logic        stall_cpu;
	 logic        irq_cpu;
	 logic 				exception_cpu;
	 logic 				irq_ack_cpu;
	 logic [31:0] irq_vector_cpu;
	 logic [31:0] address_cpu;
	 logic [31:0] data_in_cpu;
	 logic [31:0] data_out_cpu;
	 logic [3:0] 	data_w_cpu;
	 logic 				data_access_cpu;

	 perfipherals_busmux bus_mux(.clock(iface.clk),
															 .reset(iface.reset),
															 .stall(iface.stall),
															 .addr_mem(iface.address),
															 .data_read_mem(iface.data_read),
															 .data_write_mem(iface.data_write),
															 .data_we_mem(iface.data_we),
															 .extio_in(iface.extio_in),
															 .extio_out(iface.extio_out),
															 .uart_read(iface.uart_rx),
															 .uart_write(iface.uart_tx), .*);

	 datapath cpu(.clock(iface.clk),
								.reset(iface.reset),
								.stall(stall_cpu),
								.irq_vector(irq_vector_cpu),
								.irq(irq_cpu),
								.irq_ack(irq_ack_cpu),
								.exception(exception_cpu),
								.address(address_cpu),
								.data_in(data_in_cpu),
								.data_out(data_out_cpu),
								.data_w(data_w_cpu),
								.data_access(data_access_cpu));
	 

endmodule
	 
`endif
