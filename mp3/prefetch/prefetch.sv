import lc3b_types::*;

module prefetch #(parameter lines = 8, log_line = 3, line_size = 128, log_word = 3)
(
	 input clk,
	 input reset,

	input pmem_write,
	
	input [15:0] l2_pmem_address,
	output lc3b_block l2_pmem_rdata,
	output logic l2_pmem_resp,
	
	output pmem_read,
	output [15:0] pmem_address,
	input lc3b_block pmem_rdata,
	
	input [15:0] I_prefetch_address,
	
	input l2_pmem_read,
	input pmem_resp,
	input D_resp,
	input I_resp,
	output logic wait_l2
);

logic [(14-log_word):0] tag;   
logic [log_line-1:0] index;
logic load_cache;
logic compare_out;		// Compare Array
logic hit;
logic invalid_data;
logic pre_resp;
logic l2_resp_sel;
logic l2_rdata_sel;
logic pmem_address_sel;
logic load_pre;
logic [15:0] prefetch_address;

/* Arrays for the Cache */
lc3b_block cache_data[lines];  	// Data
logic valid_data[lines];				// Valid
logic [(14-log_word):0] tag_data[lines];			// Tag

cache_control_pre PRE_CONTROL
(
	.*
);

assign index = pmem_address[log_line+4:log_word+1];
assign tag = pmem_address[15:log_word+1];

mux2 #(.width(16)) PMEM_ADDR_MUX
(
	.sel(pmem_address_sel),
	.a(l2_pmem_address),
	.b( prefetch_address),
	.f(pmem_address)
);

mux2 #(.width(256)) L2_RDATA_MUX
(
	.sel(l2_rdata_sel),
	.a(cache_data[index]),
	.b(pmem_rdata),
	.f(l2_pmem_rdata)
);

mux2 #(.width(1)) L2_RESP_MUX
(
	.sel(l2_resp_sel | pmem_write),
	.a(pre_resp),
	.b(pmem_resp),
	.f(l2_pmem_resp)
);

/* Compare the tags */
compare #(.width(15 - log_word)) COMPARE_PRE
(
	.a(tag_data[index]),
	.b(tag),
	.out(compare_out)
);

assign hit = valid_data[index] & compare_out;

/* Assign Cache Load */
assign load_cache = (load_pre & pmem_resp);
assign invalid_data = (pmem_write & hit);


always_ff @(posedge clk or posedge reset)
begin
	/* Invalidate the data */
	if(reset)
	 begin
	 prefetch_address = 0;
		for (int line = 0; line < lines; line++)
		 begin
			valid_data[line] = 0;
		 end
	  end
	/* Load the cache data, valid, tag, and dirty arrays */
   else if(I_resp)
	prefetch_address = I_prefetch_address;
   else if (invalid_data )
   begin
	valid_data[index] = 0;
   end

   else if (load_cache)
    begin
	cache_data[index] = pmem_rdata;
	valid_data[index] = 1;
	tag_data[index] = tag;
    end

end


endmodule : prefetch
