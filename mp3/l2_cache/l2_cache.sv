import lc3b_types::*;

module l2_cache #(parameter way = 2, data_words = 128, lines = 8)
(
	 input clk,
	 input reset,
	 
	    /* Memory signals */
    output logic mem_resp,
    output logic [127:0] mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_word mem_address,
    input logic [127:0] mem_wdata,
	 
	 input pmem_resp,
    input [127:0] pmem_rdata,
	 output logic pmem_read,
    output logic pmem_write,
    output logic [15:0] pmem_address,
    output logic [127:0] pmem_wdata
);

logic sel_way_mux;
logic pmem_mux_sel;
logic hit;
logic dirty;
logic real_mem_resp;

assign mem_resp = real_mem_resp;

l2_cache_control CACHE_CONTROL (
	.*
);


l2_cache_datapath #(.way(way), .data_words(data_words), .lines(lines)) CACHE_DATAPATH (
	.*
);

endmodule : l2_cache
