`ifndef DUT_TOP_SV
 `define DUT_TOP_SV

 `include "hfrv_interface.sv"

module dut_top (hfrv_interface.cpu iface);

   logic        stall_cpu;
   logic        irq_cpu;
   logic        exception_cpu;
   logic        irq_ack_cpu;
   logic [31:0] irq_vector_cpu;
   logic [31:0] address_cpu;
   logic [31:0] data_in_cpu;
   logic [31:0] data_out_cpu;
   logic [3:0]  data_w_cpu;
   logic        data_access_cpu;

   logic [7:0]  ext_irq;
   logic [7:0]  ext_orq;

   // local use
   bit [31:0] data_write_periph, data_read_periph_s, data_read_periph, data_read_boot, data_read_ram;
   bit periph, periph_wr, periph_irq, ram_dly, boot_enable_n, ram_enable_n, periph_dly;
   bit [7:0] gpioa_in, gpioa_out, gpioa_ddr;

   processor cpu(	
         	.clk_i   (iface.clk),
			   .rst_i	(iface.reset),
			   .stall_i	(iface.stall),
			   .addr_o	(iface.address),
			   .data_i 	(iface.data_read),
			   .data_o 	(iface.data_write),
			   .data_w_o(iface.data_we),
			   .extio_in(ext_irq),
			   .extio_out(ext_orq)
	);

	peripherals perif(
		.clk_i 		(iface.clk),
		.rst_i		(iface.reset),
		.addr_i 	   (iface.address),
		.data_i		(data_write_periph),
		.data_o		(data_read_periph_s),
		.sel_i		(periph),
		.wr_i 		(periph_wr),
		.irq_o 		(periph_irq),
		.gpioa_in	(gpioa_in),
		.gpioa_out	(gpioa_out),
		.gpioa_ddr 	(gpioa_ddr)
	);




	always@(iface.address or iface.stall or iface.reset)
	begin
		if ((iface.address[31:28] == 4'b0000 && iface.stall == 0) || iface.reset == 1)
			boot_enable_n = 0;
		else	
			boot_enable_n = 1;
	end

	always@(iface.address or iface.stall or iface.reset or ram_enable_n)
	begin
		if ((iface.address[31:28] == 4'b0100 && iface.stall == 0) || iface.reset == 1)
			ram_enable_n = 0;
		else
			ram_enable_n = 1;
	end

	assign data_w_n_ram = ~iface.data_we;

	// New atributions
	always@(posedge iface.clk, iface.reset)
	begin
		if (iface.reset == 1) begin
			ram_dly <= 0;
			periph_dly <= 0;
		end else begin
			ram_dly <= ~ram_enable_n;
			periph_dly <= periph;
		end
	end

	always@(iface.address)
	begin
		if (iface.address[31:28] == 4'he)
			periph = 1;
		else
			periph = 0;
	end

	always@(iface.data_we)
	begin
		if (iface.data_we != 4'b0000)
			periph_wr = 1;
		else
			periph_wr = 0;
	end

	always@(iface.data_write)
	begin
		data_write_periph <= {iface.data_write[7:0], iface.data_write[15:8], iface.data_write[23:16], iface.data_write[31:24]};
	end

	always@(data_read_periph_s)
	begin
		data_read_periph <= {data_read_periph_s[7:0], data_read_periph_s[15:8], data_read_periph_s[23:16], data_read_periph_s[31:24]};
	end

	always@(data_read_periph or periph or periph_dly or iface.address or ram_dly or data_read_ram or data_read_boot or data_read_periph)
	begin
		if (periph == 1 || periph_dly == 1) 
			iface.data_read = data_read_periph;
		else if (iface.address[31:28] == 4'b0000 && ram_dly == 0)
			iface.data_read = data_read_boot;
		else
			iface.data_read = data_read_ram;
	end

	always@(periph_irq)
	begin
		ext_irq <= {7'b0000000, periph_irq};
	end


   

endmodule

`endif
