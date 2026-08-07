vlib work
vlog ../code/RTL/spi_wrapper.v ../code/RTL/sp_syn_ram.v ../code/RTL/spi_slave.v ../code/testbenches/spi_wrapper_tb.v
vsim -voptargs=+acc -msgmode both work.spi_wrapper_tb
add wave *
#do ../code/scripts/waveforms/wave_spi_wrapper.do
run -all
