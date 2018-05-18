
`timescale 1ns/1ns

module test_hf_riscv (interface_cpu_busmux cpu_busmux, interface_busmux_mem busmux_mem);

	bit stall;
	integer f, line_length;
	
	initial
	begin
		f = $fopen("sv_debug.txt","w");			
	end
	
	initial
	begin
	
		cpu_busmux.reset <= 0; 
		#5;
		cpu_busmux.reset <= 1;
		#500;
		cpu_busmux.reset <= 0;
	end

	always #123 stall = ~stall;
	assign cpu_busmux.stall = 0; // stall

	// Verification process
	always@(posedge cpu_busmux.clock_in)
	begin
		if (busmux_mem.address == 32'he0000000)
		begin
			$display("end of simulation");
			$fclose(f);  
			$finish;
		end
		if (busmux_mem.address > 32'h50000000 && (busmux_mem.address < 32'hf0000000))
		begin	
			$display("out of memory region");
			$finish;
		end
		if (busmux_mem.address == 32'h40000100)	
			$display("handling IRQ");
	end

	// Debug process
	always@(posedge cpu_busmux.clock_in)
	begin
		if (busmux_mem.address == 32'hf00000d0)
		begin			
			$fwrite(f,"%c",busmux_mem.data_write[30:24]);
			if (busmux_mem.data_write[30:24] == 10)
				line_length = 0;
			else
				line_length = line_length + 1;		
		end	
		
		else if (line_length >= 72)
		begin
			$fwrite(f,"\n");
			$fwrite(f,"%c",busmux_mem.data_write[30:24]);	
			line_length = 0;		
		end
	end
     
endmodule
