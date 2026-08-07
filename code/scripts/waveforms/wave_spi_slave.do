onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_slave_tb/dut/clk
add wave -noupdate /spi_slave_tb/dut/rst_n
add wave -noupdate /spi_slave_tb/dut/SS_n_i
add wave -noupdate /spi_slave_tb/dut/MOSI_i
add wave -noupdate /spi_slave_tb/dut/tx_data_i
add wave -noupdate /spi_slave_tb/dut/tx_valid_i
add wave -noupdate /spi_slave_tb/dut/current_state_seq
add wave -noupdate /spi_slave_tb/dut/next_state_seq
add wave -noupdate /spi_slave_tb/dut/ram_data_word_seq
add wave -noupdate /spi_slave_tb/dut/read_address_obtained_seq
add wave -noupdate /spi_slave_tb/dut/bit_count_seq
add wave -noupdate /spi_slave_tb/dut/spi_input_shift_reg_seq
add wave -noupdate /spi_slave_tb/dut/spi_output_shift_reg_seq
add wave -noupdate /spi_slave_tb/dut/MISO_o
add wave -noupdate /spi_slave_tb/dut/rx_data_o
add wave -noupdate /spi_slave_tb/dut/rx_valid_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {172 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {0 ns} {188 ns}
