onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_processing/clk_i
add wave -noupdate /tb_processing/rst_i
add wave -noupdate /tb_processing/run_stb_i
add wave -noupdate /tb_processing/rdy_stb_o
add wave -noupdate /tb_processing/rdy_stb_o_prev
add wave -noupdate -radix unsigned /tb_processing/dut/data_0_o
add wave -noupdate -radix unsigned /tb_processing/dut/data_1_o
add wave -noupdate -radix unsigned /tb_processing/dut/data_2_o
add wave -noupdate -radix unsigned /tb_processing/dut/data_3_o
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/data_i(0)
add wave -noupdate /tb_processing/dut/prc_top(0)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/prc_sens_val(0)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/data_i(1)
add wave -noupdate /tb_processing/dut/prc_top(1)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/prc_sens_val(1)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/data_i(2)
add wave -noupdate /tb_processing/dut/prc_top(2)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/prc_sens_val(2)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/data_i(3)
add wave -noupdate /tb_processing/dut/prc_top(3)
add wave -noupdate -format Analog-Step -height 20 -max 10304500.0 -radix unsigned /tb_processing/dut/prc_sens_val(3)
add wave -noupdate -format Analog-Step -height 50 -max 8000.0 -radix unsigned /tb_processing/dut/prc_point_cnt
add wave -noupdate /tb_processing/dut/prc_fsm_state
add wave -noupdate /tb_processing/dut/prc_sens_cnt(0)
add wave -noupdate -radix unsigned /tb_processing/dut/prc_point(0)
add wave -noupdate -radix unsigned /tb_processing/dut/prc_point(1)
add wave -noupdate -radix unsigned /tb_processing/dut/prc_point(2)
add wave -noupdate -radix unsigned /tb_processing/dut/prc_point(3)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63150 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {160312 ns} {160731 ns}
