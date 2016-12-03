import lc3b_types::*;

module mp3
(
    input clk,
	
	/* Switch to 256 bit at some point */
	input pmem_resp,
    input lc3b_block pmem_rdata,
	output logic pmem_read,
    output logic pmem_write,
    output logic [15:0] pmem_address,
    output lc3b_block pmem_wdata

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

/* Indirect Input */
logic P_mem_resp;
logic P_mem_read;
logic P_mem_write;
lc3b_word P_mem_address;
lc3b_word P_mem_wdata;
lc3b_word P_mem_rdata;
lc3b_mem_wmask P_mem_byte_enable;
logic indirect;

/* Arbitor In/Out */
logic D_pmem_resp;
lc3b_block D_pmem_rdata;
logic D_pmem_read;
logic D_pmem_write;
lc3b_word D_pmem_address;
lc3b_block D_pmem_wdata;

logic I_pmem_resp;
lc3b_block I_pmem_rdata;
logic I_pmem_read;
lc3b_word I_pmem_address;

logic reset;

/* L2 Cache In/Out */
logic L2_mem_resp;
logic L2_mem_read;
logic L2_mem_write;
lc3b_word L2_mem_address;
lc3b_block L2_mem_wdata;
lc3b_block L2_mem_rdata;

logic L2_pmem_read;
logic [15:0] L2_pmem_address;
lc3b_block L2_pmem_rdata;
logic L2_pmem_resp;


/* Prefetch Signals */
logic I_prefetch;
logic [15:0] I_prefetch_address;

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
    .icache_pmem_address(I_mem_address),
    .dcache_pmem_read(D_pmem_read),
    .dcache_pmem_write(D_pmem_write),
    .dcache_pmem_address(D_pmem_address),
    .dcache_pmem_wdata(D_pmem_wdata),
    .dcache_mem_rdata(D_pmem_rdata),
    .icache_mem_rdata(I_pmem_rdata),
    .dcache_mem_resp(D_pmem_resp),
    .icache_mem_resp(I_pmem_resp),
    .l2_pmem_read(L2_mem_read),
    .l2_pmem_resp(L2_mem_resp),
    .l2_pmem_rdata(L2_mem_rdata),
    .l2_pmem_write(L2_mem_write),
    .l2_pmem_address(L2_mem_address),
    .l2_pmem_wdata(L2_mem_wdata)
);

datapath DATAPATH (
	.*
);

indirect INDIRECT (
	.*
);

cache_d  #(.way(2), .data_words(16), .log_word(4), .lines(8), .log_line(3), .line_size(256)) D_CACHE (
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



cache_l2 #(.way(2), .lines(8), .log_line(3), .line_size(256), .log_word(4)) L2_CACHE (
	/* clk, reset */
	.clk(clk),
	.reset(reset),

	/* L2__Cache to/from Arbitor */
	.mem_resp(L2_mem_resp),
	.mem_rdata(L2_mem_rdata),
	.mem_read(L2_mem_read),
	.mem_write(L2_mem_write),
	.mem_address(L2_mem_address),
	.mem_wdata(L2_mem_wdata),

	/* L2_Cache to/from phys mem */
	.pmem_resp(L2_pmem_resp),
	.pmem_rdata(L2_pmem_rdata),
	.pmem_read(L2_pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(L2_pmem_address),
	.pmem_wdata(pmem_wdata)

);

prefetch PREFETCH 
(
	/* clk, reset */
	.clk(clk),
	.reset(reset),
	/* L2_Control */
	.l2_pmem_address(L2_pmem_address),
	.l2_pmem_read(L2_pmem_read),
	.l2_pmem_rdata(L2_pmem_rdata),
	.l2_pmem_resp(L2_pmem_resp),
	/* To check for invalidation */
	.pmem_write(pmem_write),
	
	/* Phys mem */
	.pmem_read(pmem_read),
	.pmem_address(pmem_address),
	.pmem_rdata(pmem_rdata),
	.pmem_resp(pmem_resp),
	
	
	.I_prefetch(I_prefetch),
	.I_prefetch_address(I_prefetch_address)
);	

cache_i #(.way(2), .data_words(16), .log_word(4), .lines(8), .log_line(3)) I_CACHE (
		/* clk, reset */
	.clk(clk),
	.reset(reset),

	/* I_Cache to/from Datapath */
	.mem_resp(I_mem_resp),
	.mem_rdata(I_mem_rdata),
	.mem_read(I_mem_read),
	.mem_address(I_mem_address),

	/* I_Cache to/from Arbitor */
	.pmem_resp(I_pmem_resp),
	.pmem_rdata(I_pmem_rdata),
	.pmem_read(I_pmem_read),
	.pmem_address(I_pmem_address)
);



endmodule : mp3
