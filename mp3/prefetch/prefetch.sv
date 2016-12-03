import lc3b_types::*;

module prefetch
(
	 input clk,
	 input reset,

	input pmem_write,
	input [15:0] l2_pmem_address,
	input l2_pmem_read,
	output lc3b_block l2_pmem_rdata,
	output logic l2_pmem_resp,
	
	output pmem_read,
	output [15:0] pmem_address,
	input lc3b_block pmem_rdata,
	input pmem_resp,
	
	input I_prefetch,
	input [15:0] I_prefetch_address
);
assign pmem_address = l2_pmem_address;
assign pmem_read = l2_pmem_read;
assign l2_pmem_rdata = pmem_rdata;
assign l2_pmem_resp = pmem_resp;


endmodule : prefetch
