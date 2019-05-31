
`timescale 1ns/1ns

module test_hf_riscv (interface_processor_peripherals processor_peripherals);

	bit stall, data;
	integer f, line_length;
	
	initial
	begin
		f = $fopen("sv_debug.txt","w");			
	end
	
	initial
	begin
	
		processor_peripherals.reset <= 0; 
		#5;
		processor_peripherals.reset <= 1;
		#500;
		processor_peripherals.reset <= 0;
	end

	always #123 stall = ~stall;
	assign processor_peripherals.stall_sig = 0; // stall

	// Verification process
	always@(posedge processor_peripherals.clock_in)
	begin
		if (processor_peripherals.address == 32'he0000000)
		begin
			$display("end of simulation");
			$fclose(f);  
			$finish;
		end
		if (processor_peripherals.address >= 32'h50000000 && (processor_peripherals.address < 32'he0000000))
		begin	
			$display("out of memory region");
			$finish;
		end
		if (processor_peripherals.address == 32'h40000104)	
			$display("handling IRQ");
	end

	// Debug process
	always@(posedge processor_peripherals.clock_in, processor_peripherals.address)
	begin
		if (processor_peripherals.address == 32'hf00000d0 && data == 0)
		begin
			data = 1;
			$fwrite(f,"%c",processor_peripherals.data_write[30:24]);
			if (processor_peripherals.data_write[30:24] == 10)
				line_length = 0;
			else
				line_length = line_length + 1;
			if (line_length >= 72) begin
				$fwrite(f,"\n");
				$fwrite(f,"%c",processor_peripherals.data_write[30:24]);	
				line_length = 0;		
			end
		end
		else begin
			data = 0; 
		end
	end
     
endmodule
