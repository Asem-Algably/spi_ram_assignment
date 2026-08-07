vlib work
vlog ../code/RTL/spi_slave.v ../code/testbenches/spi_slave_tb.v
vsim -voptargs=+acc -msgmode both work.spi_slave_tb
do ../code/scripts/waveforms/wave_spi_slave.do
run -all

