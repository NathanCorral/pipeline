import lc3b_types::*;

module cache_datapath_i #(parameter way = 2, data_words =8, log_word = 3, lines = 8, log_line = 3)
(
	 input clk,
	 input reset,

    output lc3b_word mem_rdata,
    input mem_read,
    input lc3b_word mem_address,
    input mem_resp,

	 
	 input pmem_resp,
    input lc3b_block pmem_rdata,
	input pmem_read,
    output logic [15:0] pmem_address,
	 
	 output logic hit,
	input sel_way_mux
);


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
logic [(14-log_word):0] tag_data[lines][way];			// Tag

/* Used to select the way of the cache */
logic sel_way;

/* Read data for each way */
logic [15:0] word_data[way];

/* load data, valid, dirty, and tag arrays */
/* mem_resp loads the LRU array */
logic load_cache;

/* Compare Tags of each way for the given index */
logic compare_out[way];		// Compare Array

/* Select valid data from compare_out */
logic [way-1:0] sel;

/* Compare the tags */
generate
genvar i;
for(i=0; i < way; i++) begin: COMPARE_I
	/* Compare for every way */
	compare #(.width(15 - log_word)) COMPAREi
	(
		.a(tag_data[index][i]),
		.b(tag),
		.out(compare_out[i])
	);
	
	/* Word select for each way */
	word_mux #(.data_words(data_words), .log_word(log_word)) WORD_MUXi
	(
		.data_out(cache_data[index][i]),
		.word_offset(word_offset),
		.out_word(word_data[i])
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
assign load_cache =(pmem_read & pmem_resp);

/* Select the way */
/* 
* This method only works for 2-way and is a sort of hack that abuses hit being set 
* with sel[1] and therefore only sel[0] is needed to select the correct way.
* need to add encoder for more ways
*/
mux2 #(.width(1)) SEL_WAY_MUX
(
	.sel(sel_way_mux),
	.a(!sel[0]),
	.b(!LRU[index]),
	.f(sel_way)
);
 
/* No write backs */
assign pmem_address = mem_address;

/* 
* Choose the word/byte for mem_rdata (with word_offset and mem_byte_enable)
*/
assign mem_rdata = word_data[sel_way];

always_ff @(posedge clk or posedge reset)
begin
	/* Invalidate the data */
	if(reset)
	 begin
		for (int line = 0; line < lines; line++)
		 begin
			LRU[line] = 0;
			for (int w = 0; w < way; w++)
			begin
				valid_data[line][w] = 0;
			end
		 end
	  end
	/* Load the cache data, valid, tag, and dirty arrays */
   else if (load_cache)
    begin
		/* Check for load LRU */
		if(mem_resp) begin
			LRU[index] = sel_way;
		end
		
		cache_data[index][sel_way] = pmem_rdata;
		valid_data[index][sel_way] = 1;
		tag_data[index][sel_way] = tag;
		
    end
    /* Load the LRU */
	else if(mem_resp) begin
		LRU[index] = sel_way;
	end
end

endmodule : cache_datapath_i
