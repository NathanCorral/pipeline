import lc3b_types::*;

module cache_datapath #(parameter way = 2, data_words = 8, lines = 8)
(
	 input clk,

    output lc3b_word mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
	 input reset,
	 input pmem_resp,
	 
    input [127:0] pmem_rdata,
	input pmem_read,
    output logic [15:0] pmem_address,
    output logic [127:0] pmem_wdata,
	 
	 output logic dirty,
	 output logic hit,
	 input sel_way_mux,
	 input pmem_mux_sel,
	 input mem_resp
);



logic cache_in_mux_sel;

// Address Division
logic [11:0] tag;   
logic [2:0] word_offset;
logic [2:0] index;

assign word_offset = mem_address[3:1];
assign index = mem_address[6:4];
assign tag = mem_address[15:4];


/* Arrays for the Cache */
logic [127: 0] cache_data[lines][way];  	// Data
logic LRU[lines];  							// LRU
logic valid_data[lines][way];				// Valid
logic dirty_data[lines][way];				// Dirty
logic [11:0] tag_data[lines][way];			// Tag

/* Used to select the way of the cache */
logic sel_way;

/* Address for pmem computed from tag output */
logic [11:0] pmem_mux_out;

/* data into the cache */
logic [127: 0] wdata;
/* Data from the cache with swapped word for mem_write */
logic [127: 0] swap_data;

/* load data, valid, dirty, and tag arrays */
/* mem_resp loads the LRU array */
logic load_cache;

/* Compare Tags of each way for the given index */
logic compare_out[way];		// Compare Array

/* Select valid data from compare_out */
logic [way-1:0] sel;

/* Assign the pmem write from cache data */
assign pmem_wdata = cache_data[index][sel_way];

/* Compare the tags */
generate
genvar i;
for(i=0; i < way; i++) begin: COMPARE
	compare #(.width(12)) COMPAREi
	(
		.a(tag_data[index][i]),
		.b(tag),
		.out(compare_out[i])
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

/* Mem response Reg */
logic mem_resp_reg;
assign mem_resp_reg = hit & (mem_read | mem_write);

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
mux2 #(.width(1)) DIRTY_MUX
(
	.sel(!LRU[index]),
	.a(dirty_data[index][0]),
	.b(dirty_data[index][1]),
	.f(dirty)
);

/* Select the correct tag for computing pmem_address */
mux2 #(.width(12)) TAG_MUX
(
	.sel(!LRU[index]),
	.a(tag_data[index][0]),
	.b(tag_data[index][1]),
	.f(pmem_mux_out)
);

/* Choose pmem_address source */
mux2 #(.width(16)) PMEM_MUX
(
	.sel(pmem_mux_sel),
	.a(mem_address),
	.b({pmem_mux_out, 4'b0}),
	.f(pmem_address)
);

/* 
* Choose the word/byte for mem_rdata (with word_offset and mem_byte_enable)
* Swap the correct word for a mem_write (with word_offset)
*/
logic [15:0] mem_rdata0;
logic [15:0] mem_rdata1;
logic [127:0] swap_data0;
logic [127:0] swap_data1;
swap_word SWAP_WORD0
(
	.mem_byte_enable(mem_byte_enable),
	.word_offset(word_offset),
	.data_out(cache_data[index][0]),
	.out_word(mem_rdata0),
	.swap_word(mem_wdata),
	.swap_data(swap_data0)
);
swap_word SWAP_WORD1
(
	.mem_byte_enable(mem_byte_enable),
	.word_offset(word_offset),
	.data_out(cache_data[index][1]),
	.out_word(mem_rdata1),
	.swap_word(mem_wdata),
	.swap_data(swap_data1)
);

/* Select data to write to cache */
mux2 #(.width(16)) SEL_RDATA
(
	.sel(sel_way),
	.a(mem_rdata0),
	.b(mem_rdata1),
	.f(mem_rdata)
);

mux2 #(.width(128)) SEL_SWAPDATA
(
	.sel(sel_way),
	.a(swap_data0),
	.b(swap_data1),
	.f(swap_data)
);

/* Select data to write to cache */
mux2 #(.width(128)) SEL_WDATA_MUX
(
	.sel(cache_in_mux_sel),
	.a(pmem_rdata),
	.b(swap_data),
	.f(wdata)
);

always_ff @(posedge clk or posedge reset)
begin
	/* Set the responce every clock cycle */
	//mem_resp <= mem_resp_reg;
	/* Invalidate the data */
	if(reset)
	 begin
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
		if(mem_resp) begin
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
end

endmodule : cache_datapath