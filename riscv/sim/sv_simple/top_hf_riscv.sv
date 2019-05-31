
`timescale 1ns/1ns

module top_hf_riscv;

	bit clock_in, periph_dly, periph, ram_enable_n, ram_dly, periph_wr, periph_irq, gpio_sig, boot_enable_n;
	bit [3:0] data_w_n_ram;
	bit [7:0] gpioa_in, gpioa_out, gpioa_ddr;
	bit [31:0] data_write_periph, data_read_periph_s, data_read_periph, data_read_boot, data_read_ram;

	interface_processor_peripherals processor_peripherals(clock_in);

	always #20 clock_in = ~clock_in;


	always@(processor_peripherals.address or processor_peripherals.stall_sig or processor_peripherals.reset)
	begin
		if ((processor_peripherals.address[31:28] == 4'b0000 && processor_peripherals.stall_sig == 0) || processor_peripherals.reset == 1)
			boot_enable_n = 0;
		else	
			boot_enable_n = 1;
	end

	always@(processor_peripherals.address or processor_peripherals.stall_sig or processor_peripherals.reset or ram_enable_n)
	begin
		if ((processor_peripherals.address[31:28] == 4'b0100 && processor_peripherals.stall_sig == 0) || processor_peripherals.reset == 1)
			ram_enable_n = 0;
		else
			ram_enable_n = 1;
	end

	assign data_w_n_ram = ~processor_peripherals.data_we;

	// New atributions
	always@(posedge clock_in, processor_peripherals.reset)
	begin
		if (processor_peripherals.reset == 1) begin
			ram_dly <= 0;
			periph_dly <= 0;
		end else begin
			ram_dly <= ~ram_enable_n;
			periph_dly <= periph;
		end
	end

	always@(processor_peripherals.address)
	begin
		if (processor_peripherals.address[31:28] == 4'he)
			periph = 1;
		else
			periph = 0;
	end

	always@(processor_peripherals.data_we)
	begin
		if (processor_peripherals.data_we != 4'b0000)
			periph_wr = 1;
		else
			periph_wr = 0;
	end

	always@(processor_peripherals.data_write)
	begin
		data_write_periph <= {processor_peripherals.data_write[7:0], processor_peripherals.data_write[15:8], processor_peripherals.data_write[23:16], processor_peripherals.data_write[31:24]};
	end

	always@(data_read_periph_s)
	begin
		data_read_periph <= {data_read_periph_s[7:0], data_read_periph_s[15:8], data_read_periph_s[23:16], data_read_periph_s[31:24]};
	end

	always@(data_read_periph or periph or periph_dly or processor_peripherals.address or ram_dly or data_read_ram or data_read_boot or data_read_periph)
	begin
		if (periph == 1 || periph_dly == 1) 
			processor_peripherals.data_read = data_read_periph;
		else if (processor_peripherals.address[31:28] == 4'b0000 && ram_dly == 0)
			processor_peripherals.data_read = data_read_boot;
		else
			processor_peripherals.data_read = data_read_ram;
	end

	always@(periph_irq)
	begin
		processor_peripherals.ext_irq <= {7'b0000000, periph_irq};
	end

	always@(gpio_sig)
	begin
		gpioa_in <= {4'b0000, gpio_sig, 3'b000};
	end

	// HF-RISC core
	processor cpu(	
         	.clk_i 		(processor_peripherals.clock_in),
			.rst_i		(processor_peripherals.reset),
			.stall_i	(processor_peripherals.stall_sig),
			.addr_o		(processor_peripherals.address),
			.data_i 	(processor_peripherals.data_read),
			.data_o 	(processor_peripherals.data_write),
			.data_w_o	(processor_peripherals.data_we),
			.extio_in 	(processor_peripherals.ext_irq),
			.extio_out 	(processor_peripherals.ext_orq)
	);

   // Peripherals / busmux logic
	peripherals perif(
		.clk_i 		(processor_peripherals.clock_in),
		.rst_i		(processor_peripherals.reset),
		.addr_i 	(processor_peripherals.address),
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
      .memory_file ("boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (0)
   )
   boot0lb(
		.clk 	(clock_in),
		.addr 	(processor_peripherals.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[7:0])
	);
   
   boot_ram #(	
      .memory_file ("boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (1)
   )
   boot0ub(
		.clk 	(clock_in),
		.addr 	(processor_peripherals.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[15:8])
	);
		
   boot_ram #(	
      .memory_file ("boot.txt"),
	  .data_width (8),
	  .address_width (12),
	  .bank (2)
   )
   boot1lb(
		.clk 	(clock_in),
		.addr 	(processor_peripherals.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[23:16])
	);
		
      
   boot_ram #(	
      .memory_file ("boot.txt"),
		.data_width (8),
		.address_width (12),
		.bank (3)
   )
   boot1ub(
		.clk 	(clock_in),
		.addr 	(processor_peripherals.address[11:2]),
		.cs_n 	(boot_enable_n),
		.we_n	(1'b1),
		.data_i (8'h00),
		.data_o (data_read_boot[31:24])
	);

    // RAM
	bram #(	
	   .memory_file ("code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (0)
	)
	memory0lb(
	   .clk 	(clock_in),
	   .addr 	(processor_peripherals.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[0]),
	   .data_i 	(processor_peripherals.data_write[7:0]),
	   .data_o	(data_read_ram[7:0])
	);

	bram #(	
	   .memory_file ("code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (1)
	)
	memory0ub(
	   .clk 	(clock_in),
	   .addr 	(processor_peripherals.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[1]),
	   .data_i 	(processor_peripherals.data_write[15:8]),
	   .data_o	(data_read_ram[15:8])
	);

	bram #(	
	   .memory_file ("code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (2)
	)
	memory1lb(
	   .clk 	(clock_in),
	   .addr 	(processor_peripherals.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[2]),
	   .data_i 	(processor_peripherals.data_write[23:16]),
	   .data_o	(data_read_ram[23:16])
	);

	bram #(	
	   .memory_file ("code.txt"),
	   .data_width (8),
	   .address_width (16),
	   .bank (3)
	)
	memory1ub(
	   .clk 	(clock_in),
	   .addr 	(processor_peripherals.address[15:2]),
	   .cs_n 	(ram_enable_n),
	   .we_n	(data_w_n_ram[3]),
	   .data_i 	(processor_peripherals.data_write[31:24]),
	   .data_o	(data_read_ram[31:24])
	);	

	// Test process
	test_hf_riscv test (processor_peripherals);

endmodule : top_hf_riscv
