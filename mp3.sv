import lc3b_types::*;

module mp3
(
    input clk,
	
	/* Switch to 256 bit at some point */
	input pmem_resp,
    input [127:0] pmem_rdata,
	output logic pmem_read,
    output logic pmem_write,
    output logic [15:0] pmem_address,
    output logic [127:0] pmem_wdata

);

/* Icache In/Out */
logic I_mem_resp;
lc3b_word I_mem_rdata;
logic I_mem_read;
lc3b_word I_mem_address;

/* Dcache In/Out */
logic D_mem_resp;
logic D_mem_read;
logic D_mem_write;
lc3b_word D_mem_address;
lc3b_word D_mem_wdata;
lc3b_word D_mem_rdata;
lc3b_mem_wmask mem_byte_enable;

/* Arbitor In/Out */
logic D_pmem_resp;
logic [127:0] D_pmem_rdata;
logic D_pmem_read;
logic D_pmem_write;
lc3b_word D_pmem_address;
logic [127:0] D_pmem_wdata;

logic I_pmem_resp;
logic [127:0] I_pmem_rdata;
logic I_pmem_read;
lc3b_word I_pmem_address;

/* L2 Cache In/Out */



cache D_CACHE (
	/* clk, reset */
	.clk(clk),
	.reset(reset),

	/* D_Cache to/from Datapath */
	.mem_resp(D_mem_resp),
	.mem_rdata(D_mem_rdata),
	.mem_read(D_mem_read),
	.mem_write(D_mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(D_mem_address),
	.mem_wdata(D_mem_wdata),

	/* D_Cache to/from Arbitor */
	.pmem_resp(D_pmem_resp),
	.pmem_rdata(D_pmem_rdata),
	.pmem_read(D_pmem_read),
	.pmem_write(D_pmem_write),
	.pmem_address(D_pmem_address),
	.pmem_wdata(D_pmem_wdata)

);

cache I_CACHE (
		/* clk, reset */
	.clk(clk),
	.reset(reset),

	/* D_Cache to/from Datapath */
	.mem_resp(I_mem_resp),
	.mem_rdata(I_mem_rdata),
	.mem_read(I_mem_read),
	.mem_write(0),
	.mem_byte_enable(0),
	.mem_address(I_mem_address),
	.mem_wdata(0),

	/* D_Cache to/from Arbitor */
	.pmem_resp(I_pmem_resp),
	.pmem_rdata(I_pmem_rdata),
	.pmem_read(I_pmem_read),
	.pmem_write(0),
	.pmem_address(I_pmem_address),
	.pmem_wdata(0)
);

datapath DATAPATH (
	.*
);



endmodule : mp3