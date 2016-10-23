import lc3b_types::*;

module cache
(
	input clk,
	
	/***input from cpu***/
	input logic mem_read,mem_write,
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	input lc3b_mem_wmask mem_byte_enable,
	
	/***output from cpu***/
	output lc3b_word mem_rdata,
	output mem_resp,
	
	/***input from memory***/
	input pmem_resp,
	input lc3b_block pmem_rdata,
	
	/***output from memory***/
	output pmem_read,
	output pmem_write,
	output lc3b_word pmem_address,
	output lc3b_block pmem_wdata
);

/***internal signal***/
logic valid0_write,valid1_write;
logic dirty0_write,dirty1_write;
logic tag0_write,tag1_write;
logic data0_write,data1_write;
logic lru_write;
logic writein_sel;
logic pmemmux_sel;
logic dirty0_in, dirty1_in;
logic hit;
logic way0_out,way1_out;
logic lru_out;
logic lru_in;
logic dirtymux_out;
logic dirty0_out,dirty1_out;



cache_control cache_control
(
	.clk,
	.hit,
	.mem_read,
	.mem_write,
	.mem_resp,
	
	/***write***/
	.lru_write, 
	.data0_write,
	.data1_write, 
	.tag0_write,
	.tag1_write,
	.valid0_write, 
	.valid1_write,
	.dirty0_write,
	.dirty1_write,
	//.tag0_write, 
	//.tag1_write,
	
	/***in***/
	.lru_in,
	.dirty0_in, 
	.dirty1_in,
	
	/***sel***/
	.pmemmux_sel,
	.writein_sel,
	
	.way0_out, 
	.way1_out,
	
	.pmem_read, 
	.pmem_write,	
	.pmem_resp,
	.mem_byte_enable,
	.lru_out,
	.dirtymux_out,
	.dirty0_out,
	.dirty1_out
	
);

cache_datapath cache_datapath
(
		.clk,
		
		/***write***/
		.valid0_write,
		.valid1_write,
		.dirty0_write,
		.dirty1_write,
		.tag0_write,
		.tag1_write,		
		.data0_write,
		.data1_write,
		.lru_write,
		
		/***sel***/
		.writein_sel,
		.pmemmux_sel,
		
		/***in***/
		.dirty0_in, 
		.dirty1_in,
		
		/***processor***/
		.mem_rdata,
		.mem_byte_enable,
		.mem_address,
		.mem_wdata,
		
		/***memory***/
		.pmem_rdata,
		.pmem_address,
		.pmem_wdata,
		
		/***out***/
		.hit,
		//output logic dirty0_out,dirty1_out,
		.way0_out,
		.way1_out,
		.lru_out,
		.lru_in,
		.dirtymux_out,
		.dirty0_out,
		.dirty1_out
		
);

endmodule: cache