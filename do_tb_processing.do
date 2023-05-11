vlib work

vcom -2008 -work work D:/ADM_START_2/_PROCESSING/processing.vhd
vlog -sv D:/ADM_START_2/_PROCESSING/tb_processing.sv

vsim work.tb_processing

do D:/ADM_START_2/_PROCESSING/wave.do

run -all
wave zoom full

 
  