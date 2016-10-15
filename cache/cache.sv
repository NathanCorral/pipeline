import lc3b_types::*;

module cache #(parameter way = 2, data_words = 128, lines = 8)
(
	 input clk,
	 
	    /* Memory signals */
    output logic mem_resp,
    output lc3b_word mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
	 input reset,
	 
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

cache_control CACHE_CONTROL (
	.*
);


cache_datapath #(.way(way), .data_words(data_words), .lines(lines)) CACHE_DATAPATH (
	.*
);

endmodule : cache
