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
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_CONTROL/state
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_CONTROL/next_state
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_DATAPATH/hit
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_DATAPATH/sel_way_mux
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_DATAPATH/sel_way
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_DATAPATH/mem_rdata0
add wave -noupdate -height 15 /mp3_tb/dut/D_CACHE/CACHE_DATAPATH/mem_rdata1
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/pcmux_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/pcmux_sel_out
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/load_pc
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/pcmux_sel_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/pcmux_sel_out_sel_ex
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/stall_load
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/stall_D
add wave -noupdate -height 15 /mp3_tb/dut/DATAPATH/stall_I
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[0][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[0][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[0]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[1][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[1][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[1]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[2][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[2][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[2]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[3][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[3][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[3]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[4][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[4][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[4]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[5][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[5][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[5]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[6][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[6][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[6]}
add wave -noupdate -height 15 -expand -subitemconfig {{/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[7][0]} {-height 15} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[7][1]} {-height 15}} {/mp3_tb/dut/I_CACHE/CACHE_DATAPATH/cache_data[7]}
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/index
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/word_offset
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/hit
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/sel_way
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/mem_rdata1
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/mem_rdata0
add wave -noupdate -height 15 /mp3_tb/dut/I_mem_address
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_CONTROL/state
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_CONTROL/next_state
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/pmem_read
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/pmem_address
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/pmem_resp
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/pmem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/swap_data0
add wave -noupdate -height 15 /mp3_tb/dut/I_CACHE/CACHE_DATAPATH/swap_data1
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/icache_pmem_read
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/icache_pmem_address
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_pmem_read
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_pmem_write
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_pmem_address
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_pmem_wdata
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_resp
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_mem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/icache_mem_rdata
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/dcache_mem_resp
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/icache_mem_resp
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_read
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_write
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_address
add wave -noupdate -height 15 /mp3_tb/dut/MEM_ARBITER/pmem_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8353932 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 232
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
WaveRestoreZoom {8261178 ps} {8525126 ps}
