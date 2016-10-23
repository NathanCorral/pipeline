import lc3b_types::*;

module cache_datapath(
		input clk,
		
		/***write***/
		input logic valid0_write,valid1_write,
		input logic dirty0_write,dirty1_write,
		input logic tag0_write,tag1_write,
		input logic data0_write,data1_write,
		input logic lru_write,
		
		/***sel***/
		input logic writein_sel,
		input logic pmemmux_sel,
		
		/***in***/
		input logic dirty0_in, dirty1_in,
		
		/***processor***/
		output lc3b_word mem_rdata,
		input lc3b_mem_wmask mem_byte_enable,
		input lc3b_word mem_address,
		input lc3b_word mem_wdata,
		
		/***memory***/
		input lc3b_block pmem_rdata,
		output lc3b_word pmem_address,
		output lc3b_block pmem_wdata,
		
		/***out***/
		output logic hit,
		//output logic dirty0_out,dirty1_out,
		output logic way0_out,way1_out,
		output logic lru_out,
		input logic lru_in,
		output logic dirtymux_out,dirty0_out,dirty1_out
		
);

/***declare internal signals***/
lc3b_tag tag;
assign tag = mem_address[15:7];
lc3b_index index;
assign index = mem_address[6:4];
lc3b_offset offset;
assign offset = mem_address[3:1];
logic valid0_out, valid1_out;
lc3b_tag tag0_out,tag1_out;
lc3b_block data0_out,data1_out;
logic way0tagcomp_out, way1tagcomp_out;
//logic dirty0_out,dirty1_out;
lc3b_block datareadmux;
lc3b_block writecombine_out;
lc3b_block datawritein;
lc3b_tag tag_out;
lc3b_block dataread_out;

/*******way0********/
array #(.width(1))valid0
(
.clk,
.write(valid0_write),
.index,
.datain(1'b1),
.dataout(valid0_out)
);

array #(.width(1))dirty0
(
.clk,
.write(dirty0_write),
.index,
.datain(dirty0_in),
.dataout(dirty0_out)
);

array #(.width(9))tag0
(
.clk,
.write(tag0_write),
.index,
.datain(tag),
.dataout(tag0_out)
);

array data0
(
.clk,
.write(data0_write),
.index,
.datain(datawritein),
.dataout(data0_out)
);

/*******way1********/
array #(.width(1))valid1
(
.clk,
.write(valid1_write),
.index,
.datain(1'b1),
.dataout(valid1_out)
);

array #(.width(1))dirty1
(
.clk,
.write(dirty1_write),
.index,
.datain(dirty1_in),
.dataout(dirty1_out)
);

array #(.width(9))tag1
(
.clk,
.write(tag1_write),
.index,
.datain(tag),
.dataout(tag1_out)
);

array data1
(
.clk,
.write(data1_write),
.index,
.datain(datawritein),
.dataout(data1_out)
);

/*****LRU******/
array #(.width(1))lru
(
.clk,
.write(lru_write),
.index,
.datain(lru_in),
.dataout(lru_out)
);

/****compare the tag******/
tag_comp way0tagcomp
(
.tagfromcache(tag0_out),
.tagfrommem(tag),
.out(way0tagcomp_out)
);

tag_comp way1tagcomp
(
.tagfromcache(tag1_out),
.tagfrommem(tag),
.out(way1tagcomp_out)
);

/*******combine with valid******/
and2input way0and
(
.tagcomp(way0tagcomp_out),
.valid(valid0_out),
.out(way0_out)
);

and2input way1and
(
.tagcomp(way1tagcomp_out),
.valid(valid1_out),
.out(way1_out)
);

/****hit*******/
or2input hitout
(
.way0(way0_out),
.way1(way1_out),
.out(hit)
);

mux2  #(.width(1)) dirtymux
(
.sel(lru_out),
.a(dirty0_out),
.b(dirty1_out),
.f(dirtymux_out)
);

/****read data*****/

mux2  #(.width(128)) datareadout
(
.sel(way1_out),
.a(data0_out),
.b(data1_out),
.f(dataread_out)
);

mux2 #(.width(128)) datareadmuxhit 
(
.sel(hit),
.a(pmem_wdata),
.b(dataread_out),
.f(datareadmux)
);

mux8 datareadmuxout
(
.sel(offset),
.a(datareadmux[15:0]),
.b(datareadmux[31:16]),
.c(datareadmux[47:32]),
.d(datareadmux[63:48]),
.e(datareadmux[79:64]),
.f(datareadmux[95:80]),
.g(datareadmux[111:96]),
.h(datareadmux[127:112]),
.out(mem_rdata)
);

/*****data write******/

/***write from cpu****/
writecombine writecombine
(
.sel(offset),
.mem_byte_enable,
.block(datareadmux),
.word(mem_wdata),
.out(writecombine_out)
);

/****write from sel******/
mux2  #(.width(128)) writein
(
.sel(writein_sel),
.a(pmem_rdata),
.b(writecombine_out),
.f(datawritein)
);

/****address to memory***/
mux2  #(.width(9)) tagmux
(
.sel(lru_out),
.a(tag0_out),
.b(tag1_out),
.f(tag_out)
);

mux2 #(.width(16)) addrressmux
(
.sel(pmemmux_sel),
.a(mem_address),
.b({tag_out,index,4'b0000}),
.f(pmem_address)
);

/****write to memory*****/
mux2 #(.width(128)) pmemwritemux
(
.sel(lru_out),
.a(data0_out),
.b(data1_out),
.f(pmem_wdata)
);

endmodule: cache_datapath