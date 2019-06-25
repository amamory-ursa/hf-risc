`ifndef DUT_TOP_SV
 `define DUT_TOP_SV

 `include "hfrv_interface.sv"

module dut_top (hfrv_interface.cpu iface);

	bit periph_dly, periph, ram_enable_n, ram_dly, periph_wr, periph_irq, gpio_sig, boot_enable_n;
	bit [3:0] data_w_n_ram;
	bit [7:0] gpioa_in, gpioa_out, gpioa_ddr;
	bit [31:0] data_write_periph, data_read_periph_s, data_read_periph, data_read_boot, data_read_ram;

	



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
		iface.extio_in <= {7'b0000000, periph_irq};
	end

	always@(gpio_sig)
	begin
		gpioa_in <= {4'b0000, gpio_sig, 3'b000};
	end

	// HF-RISC core
	processor cpu(	
         	.clk_i 		(iface.clk),
			.rst_i		(iface.reset),
			.stall_i	(iface.stall),
			.addr_o		(iface.address),
			.data_i 	(iface.data_read),
			.data_o 	(iface.data_write),
			.data_w_o	(iface.data_we),
			.extio_in 	(iface.extio_in),
			.extio_out 	(iface.extio_out)
	);

   // Peripherals / busmux logic
	peripherals perif(
		.clk_i 		(iface.clk),
		.rst_i		(iface.reset),
		.addr_i 	(iface.address),
		.data_i		(data_write_periph),
		.data_o		(data_read_periph_s),
		.sel_i		(periph),
		.wr_i 		(periph_wr),
		.irq_o 		(periph_irq),
		.gpioa_in	(gpioa_in),
		.gpioa_out	(gpioa_out),
		.gpioa_ddr 	(gpioa_ddr)
	);

   // Boot ROM
   boot_ram #(	
      .memory_file ("../scripts/boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (0)
   )
   boot0lb(
		.clk 	(iface.clk),
		.addr 	(iface.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[7:0])
	);
   
   boot_ram #(	
      .memory_file ("../scripts/boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (1)
   )
   boot0ub(
		.clk 	(iface.clk),
		.addr 	(iface.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[15:8])
	);
		
   boot_ram #(	
      .memory_file ("../scripts/boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (2)
   )
   boot1lb(
		.clk 	(iface.clk),
		.addr 	(iface.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[23:16])
	);
		
      
   boot_ram #(	
      .memory_file ("../scripts/boot.txt"),
		.data_width (8),
		.address_width (12),
		.bank (3)
   )
   boot1ub(
		.clk 	(iface.clk),
		.addr 	(iface.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[31:24])
	);

    // RAM
	bram #(	
	   .memory_file ("../scripts/code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (0)
	)
	memory0lb(
	   .clk 	(iface.clk),
	   .addr 	(iface.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[0]),
	   .data_i 	(iface.data_write[7:0]),
	   .data_o	(data_read_ram[7:0])
	);

	bram #(	
	   .memory_file ("../scripts/code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (1)
	)
	memory0ub(
	   .clk 	(iface.clk),
	   .addr 	(iface.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[1]),
	   .data_i 	(iface.data_write[15:8]),
	   .data_o	(data_read_ram[15:8])
	);

	bram #(	
	   .memory_file ("../scripts/code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (2)
	)
	memory1lb(
	   .clk 	(iface.clk),
	   .addr 	(iface.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[2]),
	   .data_i 	(iface.data_write[23:16]),
	   .data_o	(data_read_ram[23:16])
	);

	bram #(	
	   .memory_file ("../scripts/code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (3)
	)
	memory1ub(
	   .clk 	(iface.clk),
	   .addr 	(iface.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[3]),
	   .data_i 	(iface.data_write[31:24]),
	   .data_o	(data_read_ram[31:24])
	);	

   

endmodule

`endif
