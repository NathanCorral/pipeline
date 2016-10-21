import lc3b_types::*;

module datapath
(
	/* clk, reset */
   input clk,
	input reset,

    /* D_Cache signals */
	 output lc3b_word D_mem_address,
	 input D_mem_resp,
	 output logic D_mem_read,
	 input lc3b_word D_mem_rdata,
	 output logic D_mem_write,
	 output lc3b_mem_wmask mem_byte_enable,
	 output lc3b_word D_mem_wdata,

	 /* I_Cache signals */

	 output lc3b_word I_mem_address,
	 input I_mem_resp,
	 output logic I_mem_read,
	 input lc3b_word I_mem_rdata
	 
);
/* Pass Through Signals */
logic [3:0] opcode_ex;
logic [3:0] opcode_mem;

logic [15:0] pc_id;
logic [15:0] pc_ex;
logic [15:0] pc_mem;
logic [15:0] pc_wb;

logic [2:0] dest_ex;
logic [2:0] dest_mem;
logic [2:0] dest_wb;

logic [15:0] alu_out_wb;


/* 
/***** Pass Siganls Through *****/
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		opcode_mem <= 0;
	end
	else begin
		opcode_mem <= opcode_ex;
	end	
end





/* MEM Control Signals */
/* MEM Input Signals */
logic [15:0] alu_out_mem;
logic [15:0] sr2_mem;

/* MEM Output Signals */



/************* EX State *************/
/* EX Control Signals */
logic [1:0] alumux1_sel;
logic [1:0] alumux2_sel;
lc3b_aluop aluop;

/* EX Input Signals */
/* alumux1 */
logic [15:0] sr1_ex;
logic [15:0] adj9_out_ex;
logic [15:0] adj11_out_ex;
logic [15:0] trapvect_ex; 
/* alumux2 */
logic [15:0] sr2_ex;
logic [15:0] adj6_out_ex;
//logic [15:0] pc_ex;
logic [15:0] immmux_out_ex; 

/* EX Internal Signals */
logic [15:0] alumux1_out;
logic [15:0] alumux2_out;
logic [15:0] alu_out;

/* Modules */
mux4 #(.width(16)) ALUMUX1
(
    .sel(alumux1_sel),
    .a(sr1_ex),
    .b(adj9_out_ex),
	.c(adj11_out_ex),
	.d(trapvect_ex),
    .f(alumux1_out)
);

mux4 #(.width(16)) ALUMUX2
(
    .sel(alumux2_sel),
    .a(sr2_ex),
    .b(adj6_out_ex),
	.c(pc_ex),
	.d(immmux_out_ex),
    .f(alumux2_out)
);

alu ALU
(
    .aluop(aluop),
    .a(alumux1_out),
    .b(alumux2_out),
    .f(alu_out)
);

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		alu_out_mem <= 0;
		sr2_mem <= 0;
	end
	else begin
		pc_mem <= pc_ex;
		alu_out_mem <= alu_out;
		sr2_mem <= sr2_ex;
	end	
end
/**************************/

/**********IF stage***************/

/* IF Control Signals */
logic load_pc;
logic[1:0] pcmux_sel;
logic stall_I;

/* IF Output Signals */
logic [15:0] ir_id;

/* IF Internal Signals */
logic [15:0] pcmux_out;
logic [15:0] pc_out;
logic [15:0] pc_plus2_out;
logic [15:0] i_cache_out;


/* Modules */
mux4 pcmux
(
	.sel(pcmux_sel),
	.a(pc_plus2_out),
	.b(alu_out_wb),
	.c(sr1_out), // careful to rename after EX stage is finished
	.d(byte_sel_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out)
);

plus2 (.width(16)) pcplus2
(
	.in(pc_out),
	.out(pc_plus2_out) 
);


/* I-Cache Interface */
	/* Stall Register update untill completed memory read from I-Cache */
stall STALLI
(
	.read(I_mem_read),
	.write(0),
	.resp(I_mem_resp),
	.stall(stall_I)
);

	 /* I_Cache signals */
assign I_mem_address = pc_out;


/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		pc_id <= 0;
		ir_id <= 0;
	end
	else if (!stall_I) begin
		ir_id <= I_mem_rdata;
		pc_id <= pc_plus2_out; 
	end
end

/**************************************/

/****** MEM stage ***********/

/* MEM control Signals */
//logic indirect
logic stall_D;

/* MEM Output Signals */
logic [15:0] mem_wb;
lc3b_mem_wmask wmask_wb;

/* Modules */

/* D-Cache Interface */
/* Stall Register update untill completed memory read from D-Cache */
stall STALLD
(
	.read(D_mem_read),
	.write(D_mem_write),
	.resp(D_mem_resp),
	.stall(stall_D)
);
assign D_mem_address = alu_out_mem;
assign D_mem_wdata = sr2_mem;


/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		alu_out_wb <= 0;
		pc_wb <= 0;
		mem_wb <= 0;
		dest_wb <= 0;
	end
	else if(!stall_D) begin
		alu_out_wb <= alu_out_mem;
		pc_wb <= pc_mem;
		dest_wb <= dest_mem;
		mem_wb <= D_mem_rdata;
		wmask_wb <= mem_byte_enable;
	end	
end

/**************************************/


/******** WB stage ********/

/* MEM Control Signals */

logic load_cc;
logic [1:0] regfilemux_sel;

/* MEM Output Signals */
logic [2:0] destmux_sel;  // careful to rename after EX stage is finished
logic [15:0] regfilemux_out; // careful to rename after EX stage is finished

/* IF Internal Signals */
logic [15:0] byte_sel_out;
logic [2:0] gencc_out;
logic [2:0] cc_out;

/* Modules */
byte_sel byte_sel
(
// alu_out_wb
// mem_wb
);

mux4 regfilemux
(
	.sel(regfilemux_sel),  // careful to rename after EX stage is finished
	.a(byte_sel_out),
	.b(pc_wb),
	.c(alu_out_wb),
	.d(),
	.f(regfilemux_out) // careful to rename after EX stage is finished
);

gencc gencc
(
	.in(regfilemux_out),  // careful to rename after EX stage is finished
	.out(gencc_out)
);

register cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

cccomp cc
(
	.nzp(dest_wb),
	.cc(cc_out),
	.branch_enable // ?????????????????????
);

mux2 /*(.width(3))*/ destmux
(
	.sel(destmux_sel),
	.a(dest_wb),
	.b(3'b111),
	.f(destmux_sel)  // careful to rename after EX stage is finished
);
endmodule : datapath
