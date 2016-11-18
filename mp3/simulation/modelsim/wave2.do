onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/clk
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/pc_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/ir_id
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/DATAPATH/rf/data[7]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[6]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[5]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[4]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[3]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[2]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[1]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[0]} {-height 15}} /mp3_tb/dut/DATAPATH/rf/data
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/load_regfile_wb
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/dest
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/in
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/opcode_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/opcode_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/opcode_mem
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/opcode_wb
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/I_mem_read
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/I_mem_resp
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/I_mem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_address
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_read
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_write
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_resp
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/P_mem_wdata
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/stall_I
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/stall_D
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/fwd1_sel_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/fwd2_sel_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/dest_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr1mux_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr2mux_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr1_out_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr2_out_id
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/fwd1_sel_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/fwd2_sel_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr1_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr2_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr1id_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr2id_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/destmux_out_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/alu_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/alu_out_mem
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/sr2_mem
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/src_a
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/src_b
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/reg_a
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/rf/reg_b
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/DATAPATH/rf/data[7]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[6]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[5]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[4]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[3]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[2]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[1]} {-height 15} {/mp3_tb/dut/DATAPATH/rf/data[0]} {-height 15}} /mp3_tb/dut/DATAPATH/rf/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {527364 ps} 0}
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
WaveRestoreZoom {506094 ps} {611268 ps}
