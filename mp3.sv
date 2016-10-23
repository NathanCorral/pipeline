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

logic reset;

/* L2 Cache In/Out */


/* Reset Control */
enum int unsigned {
	 s_reset,
    s_run
} state, next_state;
always_comb
begin
	case (state)
		s_reset : begin
				reset = 1;
				next_state <= s_run;
		end
		s_run : begin
				reset = 0;
				next_state <= s_run;
		end
	endcase
end
always_ff @(posedge clk)
begin
	state <= next_state;
end

/* 
 * This arbiter scheme assumes that we won't be writing data
 * into any instruction memory (this is not the same as assuming
 * the i-cache will not be writing data, this is assuming that
 * the d-cache will not invalidate any data in the i-cache)
 */
arbiter MEM_ARBITER
(
	 .clk(clk),
    .icache_pmem_read(I_pmem_read),
    .icache_pmem_address(I_pmem_address),
    .dcache_pmem_read(D_pmem_read),
    .dcache_pmem_write(D_pmem_write),
    .dcache_pmem_address(D_pmem_address),
    .dcache_pmem_wdata(D_pmem_wdata),
    .pmem_resp(pmem_resp),
    .pmem_rdata(pmem_rdata),
	 .dcache_mem_rdata(D_pmem_rdata),
    .icache_mem_rdata(I_pmem_rdata),
    .dcache_mem_resp(D_pmem_resp),
    .icache_mem_resp(I_pmem_resp),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .pmem_address(pmem_address),
    .pmem_wdata(pmem_wdata)
);

cache D_CACHE (
	/* clk, reset */
	.clk(clk),
	//.reset(reset),

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
	//.reset(reset),

	/* I_Cache to/from Datapath */
	.mem_resp(I_mem_resp),
	.mem_rdata(I_mem_rdata),
	.mem_read(I_mem_read),
	.mem_write(1'b0),
	.mem_byte_enable(2'b0),
	.mem_address(I_mem_address),
	.mem_wdata(16'b0),

	/* I_Cache to/from Arbitor */
	.pmem_resp(I_pmem_resp),
	.pmem_rdata(I_pmem_rdata),
	.pmem_read(I_pmem_read),
    .pmem_write(),
	.pmem_address(I_pmem_address),
    .pmem_wdata()
);

datapath DATAPATH (
	.*
);



endmodule : mp3
