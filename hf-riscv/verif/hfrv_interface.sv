`ifdef HFRV_INTERFACE_SV
 `define HFRV_INTERFACE_SV

interface hfrv_interface(input logic clk);
	 logic reset;
	 logic stall;
	 
	 logic [31:0] address;
	 logic [31:0] data_read;
	 logic [31:0] data_write;
	 logic [3:0] 	data_we;

	 logic [7 downto 0] extio_in;
	 logic [7 downto 0] extio_out;
	 logic 							uart_rx;
	 logic 							uart_tx;

	 clocking mem @(posedge clk);
			input 					address;
			input 					data_write;
			input 					data_we;
			output 					data_read;
	 endclocking; // drv_cb

	 modport uart(input uart_tx,
								output uart_rx);

	 modport gpio(input extio_out, output extio_in);

	 modport memory(input reset,
									clocking mem);

	 modport driver(output reset, stall,
									clocking mem);

	 modport monitor(input reset, stall,
									 clocking mem);

	 modport cpu(input reset, clk, data_read, extio_in, uart_rx,
							 output address, data_write, data_we, extio_out, uart_tx);
	 
endinterface; // hfrv_interface

`endif
