import lc3b_types::*;

module cache_datapath_d #(parameter way = 2, data_words = 8, log_word = 3, lines = 8, log_line = 3, line_size = 128)
(
	 input clk,
	 input reset,

    output lc3b_word mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
	 input pmem_resp,
	 
    input lc3b_block pmem_rdata,
	input pmem_read,
    output logic [15:0] pmem_address,
    output lc3b_block pmem_wdata,
	 
	 output logic dirty,
	 output logic hit,
	input sel_way_mux,
	 input pmem_mux_sel,
	 input mem_resp
);



logic cache_in_mux_sel;

// Address Division
logic [(14-log_word):0] tag;   
logic [log_word-1:0] word_offset;
logic [log_line-1:0] index;

assign word_offset = mem_address[log_word:1];
assign index = mem_address[log_line+4:log_word+1];
assign tag = mem_address[15:log_word+1];


/* Arrays for the Cache */
lc3b_block cache_data[lines][way];  	// Data
logic LRU[lines];  							// LRU
logic valid_data[lines][way];				// Valid
logic dirty_data[lines][way];				// Dirty
logic [(14-log_word):0] tag_data[lines][way];			// Tag

/* Used to select the way of the cache */
logic sel_way;

/* Address for pmem computed from tag output */
logic [(14-log_word):0] pmem_mux_out;

/* data into the cache */
lc3b_block wdata;
/* Data from the cache with swapped word for mem_write */
lc3b_block swap_data;
/* Data from the cache with swapped word for mem_write */
lc3b_block swap[way];

/* load data, valid, dirty, and tag arrays */
/* mem_resp loads the LRU array */
logic load_cache;

/* Compare Tags of each way for the given index */
logic compare_out[way];		// Compare Array

/* Select valid data from compare_out */
logic [way-1:0] sel;

/* Read data for each way */
logic [15:0] word_data[way];

/* Assign the pmem write from cache data */
lc3b_block pmem_wdata_reg;
assign pmem_wdata = pmem_wdata_reg;

/* Compare the tags */
generate
genvar i;
for(i=0; i < way; i++) begin: COMPARE_D
	compare #(.width(15 - log_word)) COMPAREi
	(
		.a(tag_data[index][i]),
		.b(tag),
		.out(compare_out[i])
	);

	swap_word #(.data_words(data_words), .log_word(log_word)) SWAP_WORDi
	(
		.mem_byte_enable(mem_byte_enable),
		.word_offset(word_offset),
		.data_out(cache_data[index][i]),
		.out_word(word_data[i]),
		.swap_word(mem_wdata),
		.swap_data(swap[i])
	);
end
endgenerate

/* Make sure the tag-compare is valid  */
always_comb begin
	for(integer i = 0; i < way; i++) begin
		sel[i] = valid_data[index][i] & compare_out[i];
	end
end

/* Assign hit */
assign hit = |sel;

/* Assign Cache Load */
assign cache_in_mux_sel = (hit & mem_write);
assign load_cache = cache_in_mux_sel | (pmem_read & pmem_resp);

/* Select the way */
/* 
* This method only works for 2-way and is a sort of hack that abuses hit being set 
* with sel[1] and therefore only sel[0] is needed to select the correct way.
*/
mux2 #(.width(1)) SEL_WAY_MUX
(
	.sel(sel_way_mux),
	.a(!sel[0]),
	.b(!LRU[index]),
	.f(sel_way)
);



/* Select Dirty */
assign dirty = dirty_data[index][!LRU[index]];



/* Choose pmem_address source */
mux2 #(.width(16)) PMEM_MUX
(
	.sel(pmem_mux_sel),
	.a(mem_address),
	.b({pmem_mux_out, 5'b0}), //log_word
	.f(pmem_address)
);

/* 
* Choose the word/byte for mem_rdata (with word_offset and mem_byte_enable)
* Swap the correct word for a mem_write (with word_offset)
*/
assign mem_rdata = word_data[sel_way];

/* Select swap data to write to cache */
assign swap_data = swap[sel_way];

/* Select data to write to cache */
mux2 #(line_size) SEL_WDATA_MUX
(
	.sel(cache_in_mux_sel),
	.a(pmem_rdata),
	.b(swap_data),
	.f(wdata)
);

always_ff @(posedge clk or posedge reset)
begin
	/* Invalidate the data */
	if(reset)
	 begin
		pmem_mux_out = 0;
		for (int line = 0; line < lines; line++)
		 begin
			LRU[line] = 0;
			for (int w = 0; w < way; w++)
			begin
				valid_data[line][w] = 0;
				dirty_data[line][w] = 0;
			end
		 end
	  end
	/* Load the cache data, valid, tag, and dirty arrays */
   else if (load_cache)
    begin
		/* Check for load LRU */
		if(hit) begin
			LRU[index] = sel_way;
		end
	
		cache_data[index][sel_way] = wdata;
		valid_data[index][sel_way] = 1;
		tag_data[index][sel_way] = tag;
		/* Only set dirty on a mem_write */
		if(!pmem_read)
			dirty_data[index][sel_way] = 1;
		
    end
    /* Load the LRU */
	else if(mem_resp) begin
		LRU[index] = sel_way;
	end
	else begin
		/* Select the correct tag for computing pmem_address */
		pmem_mux_out = tag_data[index][!LRU[index]];
		pmem_wdata_reg = cache_data[index][!LRU[index]]; 
	end
end

endmodule : cache_datapath_d
