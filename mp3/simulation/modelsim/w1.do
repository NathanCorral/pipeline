onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/pmem_resp
add wave -noupdate /mp3_tb/pmem_read
add wave -noupdate /mp3_tb/pmem_write
add wave -noupdate /mp3_tb/pmem_address
add wave -noupdate /mp3_tb/pmem_rdata
add wave -noupdate /mp3_tb/pmem_wdata
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_resp
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_rdata
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_read
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_write
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_address
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_wdata
add wave -noupdate /mp3_tb/dut/L2_CACHE/CACHE_DATAPATH/hit
add wave -noupdate -expand /mp3_tb/dut/L2_CACHE/CACHE_DATAPATH/cache_data
add wave -noupdate /mp3_tb/dut/L2_CACHE/CACHE_DATAPATH/wdata
add wave -noupdate /mp3_tb/dut/L2_CACHE/CACHE_DATAPATH/load_cache
add wave -noupdate -expand /mp3_tb/dut/L2_CACHE/CACHE_DATAPATH/sel
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_resp
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_rdata
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_read
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_write
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_address
add wave -noupdate /mp3_tb/dut/L2_CACHE/mem_wdata
add wave -noupdate /mp3_tb/dut/DATAPATH/pc_out
add wave -noupdate /mp3_tb/dut/DATAPATH/I_mem_read
add wave -noupdate /mp3_tb/dut/DATAPATH/I_mem_resp
add wave -noupdate /mp3_tb/dut/DATAPATH/I_mem_rdata
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_read
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_write
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_resp
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_address
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_rdata
add wave -noupdate /mp3_tb/dut/DATAPATH/P_mem_wdata
add wave -noupdate /mp3_tb/dut/DATAPATH/rf/data
add wave -noupdate /mp3_tb/dut/DATAPATH/opcode_id
add wave -noupdate /mp3_tb/dut/DATAPATH/opcode_ex
add wave -noupdate /mp3_tb/dut/DATAPATH/opcode_mem
add wave -noupdate /mp3_tb/dut/DATAPATH/opcode_wb
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/icache_mem_resp
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/icache_pmem_read
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/icache_mem_rdata
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/icache_pmem_address
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_pmem_read
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_pmem_write
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_pmem_address
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_pmem_wdata
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_mem_rdata
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/dcache_mem_resp
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_rdata
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_resp
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_read
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_write
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_address
add wave -noupdate /mp3_tb/dut/MEM_ARBITER/l2_pmem_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {301604 ps} 0}
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
WaveRestoreZoom {284468 ps} {429469 ps}
