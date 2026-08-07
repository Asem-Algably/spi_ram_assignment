onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/clk
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/rst_n
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/SS_n_i
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/MOSI_i
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/MISO_o
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/bits_to_be_sent
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/write_address
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/write_data
add wave -noupdate -expand -group wrapper_tb /spi_wrapper_tb/i
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/clk
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/rst_n
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/din_i
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/dout_o
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/mem
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/read_address_reg
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/write_address_reg
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/rx_valid_i
add wave -noupdate -expand -group ram /spi_wrapper_tb/uut_spi_wrapper/inst_sp_syn_ram/tx_valid_o
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/clk
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/rst_n
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/SS_n_i
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/bit_count_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/current_state_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/next_state_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/MISO_o
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/MOSI_i
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/ram_data_word_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/read_address_obtained_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/rx_data_o
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/rx_valid_o
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/spi_input_shift_reg_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/spi_output_shift_reg_seq
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/tx_data_i
add wave -noupdate -expand -group spi_slave /spi_wrapper_tb/uut_spi_wrapper/inst_spi_slave/tx_valid_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {565 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 250
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
WaveRestoreZoom {343 ns} {575 ns}
