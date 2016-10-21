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

/**********IF stage***************/

/* IF Control Signals */
logic load_pc;
logic[1:0] pcmux_sel_out;
logic stall_I;

/* IF Output Signals */
logic [15:0] ir_id;

/* IF Internal Signals */
logic [15:0] pcmux_out;
logic [15:0] pc_out;
logic [15:0] pc_plus2_out;
logic [15:0] i_cache_out;

assign load_pc = ~stall_I;

/* Modules */
mux4 pcmux
(
	.sel(pcmux_sel_out),
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

/**********ID stage***************/

/* ID Control Signals */
logic sr1_sel_id;
logic sr2_sel_id;
logic sh6_sel_id;
logic imm_sel_id;

/* ID Output Signals */
logic load_regfile_id;
logic [1:0] alumux1_sel_id;
logic [1:0] alumux2_sel_id;
lc3b_aluop aluop_id;
logic indirect_id;
logic mem_read_id;
logic mem_write_id;
logic mem_byte_enable_id;
logic regfilemux_sel_id;
logic load_cc_id;
logic branch_enable_id;
logic destmux_sel_id;
logic pcmux_sel_id;
logic pcmux_sel_out_sel_id;

/* ID Internal Signals */
logic [15:0] adj6_out_id;
logic [15:0] adj9_out_id;
logic [15:0] adj11_out_id;
logic [15:0] trapvect_id;
logic [15:0] sr1_out_id;
logic [15:0] sr2_out_id;
logic [15:0] immmux_out_id;
logic [3:0] opcode_id;
logic [2:0] dest_id;
logic [2:0] sr1mux_out;
logic [2:0] sr2mux_out;

/* Modules */
assign trapvect_id = {7'b0, ir_id[7:0], 1'b0};
assign dest_id = ir_id[11:9];
assign opcode_id = ir_id[15:12];

adj #(.width(9)) ADJ9
(
    .in(ir_id[8:0]),
    .out(adj9_out_id)
);

adj #(.width(11)) ADJ11
(
    .in(ir_id[10:0]),
    .out(adj11_out_id)
);

mux2 #(.width(3)) SR1MUX
(
    .sel(sr1_sel_id),
    .a(ir_id[8:6]),
    .b(dest_id),
    .f(sr1mux_out)
);

mux2 #(.width(3)) SR2MUX
(
    .sel(sr2_sel_id),
    .a(ir_id[2:0]),
    .b(dest_id),
    .f(sr2mux_out)
);

regfile rf
(
    .clk(clk),
    .reset(reset),
    .load(load_regfile_wb),
    .in(regfilemux_out), // rename later?
    .src_a(sr1mux_out),
    .src_b(sr2mux_out),
    .dest(destmux_out),
    .reg_a(sr1_out_id),
    .reg_b(sr2_out_id)
);

mux2 #(.width(16)) ADJ6MUX
(
    .sel(sh6_sel_id),
    .a({{9{ir_id[5]}}, ir_id[5:0], 1'b0}),
    .b({{10{ir_id[5]}}, ir_id[5:0]}),
    .f(adj6_out_id)
);

mux2 #(.width(16)) IMMMUX
(
    .sel(imm_sel_id),
    .a({{11{ir_id[4]}}, ir_id[4:0]}),
    .b({12'b0, ir_id[3:0]}),
    .f(immmux_out_id)
);

decode INST_DECODER
(
    .instruction(ir_id),
    .sr1_sel(sr1_sel_id),
    .sr2_sel(sr2_sel_id),
    .sh6_sel(sh6_sel_id),
    .imm_sel(imm_sel_id),
    .alumux1_sel(alumux1_sel_id),
    .alumux2_sel(alumux2_sel_id),
    .alu_ctrl(aluop_id),
    .indirect(indirect_id),
    .read(mem_read_id),
    .write(mem_write_id),
    .mem_byte_sig(mem_byte_enable_id),
    .load_regfile(load_regfile_id),
    .regfilemux_sel(regfilemux_sel_id),
    .load_cc(load_cc_id),
    .destmux_sel(destmux_sel_id),
    .pcmux_sel(pcmux_sel_id)
    .pcmux_sel_out_sel(pcmux_sel_out_sel_id)
);

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
        alumux1_sel_ex <= 0;
        alumux2_sel_ex <= 0;
        aluop_ex <= 0;
        indirect_ex <= 0;
        mem_byte_enable_ex <= 0;
        regfilemux_sel_ex <= 0;
        load_cc_ex <= 0;
        branch_enable_ex <= 0;
        destmux_sel_ex <= 0;
        pcmux_sel_ex <= 0;
	end
	else begin
        /* data signal assignments */
        sr1_ex <= sr1_out_id;
        adj9_out_ex <= adj9_out_id;
        adj11_out_ex <= adj11_out_id;
        trapvect_ex <= trapvect_id;
        sr2_ex <= sr2_out_id;
        adj6_out_ex <= adj6_out_id;
        pc_ex <= pc_id;
        immmux_out_ex <= immmux_out_id;
        opcode_ex <= opcode_id;
        /* control signal assignments */
        alumux1_sel_ex <= alumux1_sel_id;
        alumux2_sel_ex <= alumux2_sel_id;
        aluop_ex <= aluop_id;
        indirect_ex <= indirect_id;
        mem_byte_enable_ex <= mem_byte_enable_id;
        regfilemux_sel_ex <= regfilemux_sel_id;
        load_cc_ex <= load_cc_id;
        branch_enable_ex <= branch_enable_id;
        destmux_sel_ex <= destmux_sel_id;
        pcmux_sel_ex <= pcmux_sel_id;
	end	
end
/**************************************/

/************* EX State *************/
/* EX Control Signals */
logic [1:0] alumux1_sel_ex;
logic [1:0] alumux2_sel_ex;
lc3b_aluop aluop_ex;

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
    .sel(alumux1_sel_ex),
    .a(sr1_ex),
    .b(adj9_out_ex),
	.c(adj11_out_ex),
	.d(trapvect_ex),
    .f(alumux1_out)
);

mux4 #(.width(16)) ALUMUX2
(
    .sel(alumux2_sel_ex),
    .a(sr2_ex),
    .b(adj6_out_ex),
	.c(pc_ex),
	.d(immmux_out_ex),
    .f(alumux2_out)
);

alu ALU
(
    .aluop(aluop_ex),
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

/****** MEM stage ***********/

/* MEM Input Signals */
logic [15:0] alu_out_mem;
logic [15:0] sr2_mem;

/* MEM control Signals */
logic indirect_mem
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
		opcode_mem <= 0;
	end
	else if(!stall_D) begin
		alu_out_wb <= alu_out_mem;
		pc_wb <= pc_mem;
		dest_wb <= dest_mem;
		mem_wb <= D_mem_rdata;
		wmask_wb <= mem_byte_enable;
		opcode_mem <= opcode_ex;
	end	
end

/**************************************/


/******** WB stage ********/

/* MEM Control Signals */

logic load_cc_wb;
logic [1:0] regfilemux_sel_wb;

/* MEM Output Signals */
logic [2:0] destmux_sel_wb;  // careful to rename after EX stage is finished
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
	.sel(regfilemux_sel_wb),  // careful to rename after EX stage is finished
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
	.load(load_cc_wb),
	.in(gencc_out),
	.out(cc_out)
);

cccomp cc
(
	.nzp(dest_wb),
	.cc(cc_out),
	.branch_enable(branch_enable_wb)
);

mux2 #(.width(2)) pcmux_sel_mux
(
    .sel(pcmux_sel_out_sel_wb),
    .a(pcmux_sel_wb),
    .b({1'b0, branch_enable_wb}),
    .f(pcmux_sel_out)
);

mux2 #(.width(3)) destmux
(
	.sel(destmux_sel_wb),
	.a(dest_wb),
	.b(3'b111),
	.f(destmux_out)
);
endmodule : datapath
