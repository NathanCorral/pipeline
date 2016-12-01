import lc3b_types::*;

module cache_l2 #(parameter way = 2, lines = 8, log_line = 3)
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

assign mem_resp = real_mem_resp & (mem_read | mem_write);

cache_control_l2 L2_CACHE_CONTROL (
	.*
);


cache_datapath_l2 #(.way(way), .lines(lines), .log_line(log_line)) L2_CACHE_DATAPATH (
	.*
);

endmodule : cache_l2
