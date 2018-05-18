onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_hf_riscv/cpu_busmux/clock_in
add wave -noupdate /top_hf_riscv/cpu_busmux/reset
add wave -noupdate /top_hf_riscv/cpu_busmux/stall
add wave -noupdate /top_hf_riscv/cpu_busmux/stall_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/irq_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/irq_ack_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/exception_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/data_access_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/irq_vector_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/address_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/data_in_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/data_out_cpu
add wave -noupdate /top_hf_riscv/cpu_busmux/data_w_cpu
add wave -noupdate /top_hf_riscv/busmux_mem/clock_in
add wave -noupdate /top_hf_riscv/busmux_mem/address
add wave -noupdate /top_hf_riscv/busmux_mem/data_read
add wave -noupdate /top_hf_riscv/busmux_mem/data_write
add wave -noupdate /top_hf_riscv/busmux_mem/data_we
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10887 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 335
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {2180025 ns}
