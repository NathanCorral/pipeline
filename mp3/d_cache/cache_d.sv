import lc3b_types::*;

module cache_d #(parameter way = 2, data_words = 8, log_word = 3, lines = 8, log_line = 3)
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
    input lc3b_block pmem_rdata,
	 output logic pmem_read,
    output logic pmem_write,
    output logic [15:0] pmem_address,
    output lc3b_block pmem_wdata
);

logic sel_way_mux;
logic pmem_mux_sel;
logic hit;
logic dirty;


cache_control_d D_CACHE_CONTROL (
	.*
);


cache_datapath_d #(.way(way), .data_words(data_words), .log_word(log_word), .lines(lines), .log_line(log_line)) D_CACHE_DATAPATH (
	.*
);

endmodule : cache_d
