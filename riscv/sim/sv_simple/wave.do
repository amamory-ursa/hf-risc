onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_hf_riscv/clock_in
add wave -noupdate /top_hf_riscv/periph_dly
add wave -noupdate /top_hf_riscv/periph
add wave -noupdate /top_hf_riscv/ram_enable_n
add wave -noupdate /top_hf_riscv/ram_dly
add wave -noupdate /top_hf_riscv/periph_wr
add wave -noupdate /top_hf_riscv/periph_irq
add wave -noupdate /top_hf_riscv/gpio_sig
add wave -noupdate /top_hf_riscv/boot_enable_n
add wave -noupdate /top_hf_riscv/data_w_n_ram
add wave -noupdate /top_hf_riscv/gpioa_in
add wave -noupdate /top_hf_riscv/gpioa_out
add wave -noupdate /top_hf_riscv/gpioa_ddr
add wave -noupdate /top_hf_riscv/data_write_periph
add wave -noupdate /top_hf_riscv/data_read_periph_s
add wave -noupdate /top_hf_riscv/data_read_periph
add wave -noupdate /top_hf_riscv/data_read_boot
add wave -noupdate /top_hf_riscv/data_read_ram
add wave -noupdate -divider interface
add wave -noupdate /top_hf_riscv/processor_peripherals/clock_in
add wave -noupdate /top_hf_riscv/processor_peripherals/reset
add wave -noupdate /top_hf_riscv/processor_peripherals/stall_sig
add wave -noupdate /top_hf_riscv/processor_peripherals/address
add wave -noupdate /top_hf_riscv/processor_peripherals/data_read
add wave -noupdate /top_hf_riscv/processor_peripherals/data_write
add wave -noupdate /top_hf_riscv/processor_peripherals/data_we
add wave -noupdate /top_hf_riscv/processor_peripherals/ext_irq
add wave -noupdate /top_hf_riscv/processor_peripherals/ext_orq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {18606 ns}
