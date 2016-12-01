import lc3b_types::*;

module cache_datapath_l2 #(parameter way = 2, lines = 8, log_line = 3)
(
	 input clk,

    output lc3b_block mem_rdata,
    input mem_read,
    input mem_write,
    input lc3b_word mem_address,
    input lc3b_block  mem_wdata,
	 input reset,
	 input pmem_resp,
	 
    input lc3b_block pmem_rdata,
	input pmem_read,
    output logic [15:0] pmem_address,
    output lc3b_block pmem_wdata,
	 
	 output logic dirty,
	 output logic hit,
	 input sel_way_mux,
	 input pmem_mux_sel,
	 input real_mem_resp
);



logic cache_in_mux_sel;

// Address Division
logic [11:0] tag;   
logic [log_line-1:0] index;

assign index = mem_address[log_line+3:4];
assign tag = mem_address[15:4];


/* Arrays for the Cache */
lc3b_block cache_data[lines][way];  	// Data
logic LRU[lines];  							// LRU
logic valid_data[lines][way];				// Valid
logic dirty_data[lines][way];				// Dirty
logic [11:0] tag_data[lines][way];			// Tag

/* Used to select the way of the cache */
logic sel_way;

/* Address for pmem computed from tag output */
logic [15:0] pmem_mux_out;

/* data into the cache */
lc3b_block wdata;

/* load data, valid, dirty, and tag arrays */
/* mem_resp loads the LRU array */
logic load_cache;

/* Compare Tags of each way for the given index */
logic compare_out[way];		// Compare Array

/* Select valid data from compare_out */
logic [way-1:0] sel;

/* Assign the pmem write from cache data */
assign pmem_wdata =cache_data[index][!LRU[index]];

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
	.b(pmem_mux_out),
	.f(pmem_address)
);

/* Select data to write to cache */
assign mem_rdata = cache_data[index][sel_way];

/* Select data to write to cache */
mux2 #(.width(128)) SEL_WDATA_MUX
(
	.sel(cache_in_mux_sel),
	.a(pmem_rdata),
	.b(mem_wdata),
	.f(wdata)
);

always_ff @(posedge clk or posedge reset)
begin
	/* Set the responce every clock cycle */
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
	else if(real_mem_resp) begin
		LRU[index] = sel_way;
	end
	else begin
		pmem_mux_out = {tag_data[index][!LRU[index]],4'b0};
	end
end

endmodule : cache_datapath_l2
