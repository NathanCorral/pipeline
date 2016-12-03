import lc3b_types::*;

module prefetch
(
	 input clk,
	 input reset,

	input no_prefetch,
	output busy,
	output ready,
	input done,
	input pmem_write,
	input [15:0] l2_pmem_address,
	
	output read,
	output [15:0] address,
	input lc3b_block pmem_rdata,
	output lc3b_block wdata
);

endmodule : prefetch
