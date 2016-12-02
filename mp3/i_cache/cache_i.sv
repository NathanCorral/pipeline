import lc3b_types::*;

module cache_i #(parameter way = 2, data_words = 8, log_word = 3, lines = 8, log_line = 3)
(
	 input clk,
	 
	    /* Memory signals */
    output logic mem_resp,
    output lc3b_word mem_rdata,
    input mem_read,
    input lc3b_word mem_address,
	 input reset,
	 
	 input pmem_resp,
    input lc3b_block pmem_rdata,
	 output logic pmem_read,
    output logic [15:0] pmem_address
);

logic hit;
logic sel_way_mux;

cache_control_i I_CACHE_CONTROL (
	.*
);


cache_datapath_i #(.way(way), .data_words(data_words), .log_word(log_word), .lines(lines), .log_line(log_line)) I_CACHE_DATAPATH (
	.*
);

endmodule : cache_i
