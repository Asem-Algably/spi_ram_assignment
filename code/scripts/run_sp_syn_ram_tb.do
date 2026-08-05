vlib work
vlog ../code/RTL/sp_syn_ram.v ../code/testbenches/sp_syn_ram_tb.v
vsim -voptargs=+acc -msgmode both work.sp_syn_ram_tb
do ../code/scripts/waveforms/wave_sp_syn_ram.do
run -all

