import lc3b_types::*;

module cache_l2 #(parameter way = 2, lines = 8, log_line = 3, line_size = 128, log_word = 3)
(
	 input clk,
	 input reset,
	 
	    /* Memory signals */
    output logic mem_resp,
    output lc3b_block mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_word mem_address,
    input lc3b_block mem_wdata,
	 
	 input pmem_resp,
    input lc3b_block pmem_rdata,
	 output logic pmem_read,
    output logic pmem_write,
    output logic [15:0] pmem_address,
    output lc3b_block pmem_wdata,

    /* Prefetch Signals */
    input prefetch_ready,
    input prefetch_busy,
    input lc3b_block prefetch_wdata,
    input logic [15:0] prefetch_address,
    output logic no_prefetch,
    output logic done_prefetch
);

logic sel_way_mux;
logic pmem_mux_sel;
logic hit;
logic dirty;
logic real_mem_resp;
logic prefetch;
logic [15:0] addr;
lc3b_block ready_wdata;

assign mem_resp = real_mem_resp & (mem_read | mem_write);

mux2 #(.width(16)) L2_ADDR_MUX
(
	.sel(prefetch),
	.a(mem_address),
	.b(prefetch_address),
	.f(addr)
);


mux2 #(.width(line_size)) L2_WDATA_MUX
(
	.sel(prefetch),
	.a(mem_wdata),
	.b(prefetch_wdata),
	.f(ready_wdata)
);

cache_control_l2 L2_CACHE_CONTROL (
	.*
);


cache_datapath_l2 #(.way(way), .lines(lines), .log_line(log_line), .line_size(line_size), .log_word(log_word)) L2_CACHE_DATAPATH (
	.mem_address(addr),
	.mem_wdata(ready_wdata),	
	.*
);

endmodule : cache_l2
