transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/stall.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/register.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas/cache {/home/scheng41/tulkas/cache/compare.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas/cache {/home/scheng41/tulkas/cache/swap_word.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas/cache {/home/scheng41/tulkas/cache/cache_control.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/plus2.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/mux4.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/mux2.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/lc3b_types.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/arbiter.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/decode.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas/cache {/home/scheng41/tulkas/cache/cache_datapath.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/regfile.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/gencc.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/cccomp.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/alu.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/adj.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/datapath.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas/cache {/home/scheng41/tulkas/cache/cache.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/mp3.sv}

vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/physical_memory.sv}
vlog -sv -work work +incdir+/home/scheng41/tulkas {/home/scheng41/tulkas/mp3_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  mp3_tb

add wave *
view structure
view signals
run 200 ns
