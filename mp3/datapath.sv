import lc3b_types::*;

module datapath
(
	/* clk, reset */
   input clk,
	input reset,

    /* D_Cache signals */
	 output logic indirect,
	 output lc3b_word P_mem_address,
	 input P_mem_resp,
	 output logic P_mem_read,
	 input lc3b_word P_mem_rdata,
	 output logic P_mem_write,
	 output lc3b_mem_wmask P_mem_byte_enable,
	 output lc3b_word P_mem_wdata,

	 /* I_Cache signals */

	 output lc3b_word I_mem_address,
	 input I_mem_resp,
	 output logic I_mem_read,
	 input lc3b_word I_mem_rdata
	 
);

/* Signal declarations */

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

logic stall_D;

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
logic [1:0] mem_byte_enable_id;
logic regfilemux_sel_id;
logic memread_sel_id;
logic load_cc_id;
// logic branch_enable_id;		// Not used?
logic destmux_sel_id;
logic [1:0] pcmux_sel_id;
logic pcmux_sel_out_sel_id;

/* ID Internal Signals */
logic [15:0] adj6_out_id;
logic [15:0] adj9_out_id;
logic [15:0] adj11_out_id;
logic [15:0] trapvect_id;
logic [15:0] sr1_out_id;
logic [15:0] sr2_out_id;
logic [15:0] immmux_out_id;
lc3b_opcode opcode_id;
logic [2:0] dest_id;
logic [2:0] sr1mux_out;
logic [2:0] sr2mux_out;

/* EX Control Signals */
logic [1:0] fwd1_sel;
logic [1:0] fwd2_sel;
logic [1:0] alumux1_sel_ex;
logic [1:0] alumux2_sel_ex;
lc3b_aluop aluop_ex;
/* Future stages */
logic load_regfile_ex;
logic indirect_ex;
logic mem_read_ex;
logic mem_write_ex;
logic [1:0] mem_byte_enable_ex;
logic regfilemux_sel_ex;
logic memread_sel_ex;
logic load_cc_ex;
//logic branch_enable_ex;
logic destmux_sel_ex;
logic [2:0] destmux_out_ex;
logic [1:0] pcmux_sel_ex;
logic pcmux_sel_out_sel_ex;




/* EX Input Signals */
/* alumux1 */
logic [2:0] sr1id_ex;
logic [2:0] sr2id_ex;
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
logic [15:0] fwdmux1_out;
logic [15:0] fwdmux2_out;

/* MEM Input Signals */
logic [15:0] alu_out_mem;
logic [15:0] sr2_mem;

/* MEM control Signals */
logic indirect_mem;
logic mem_read_mem;
logic mem_write_mem;
logic [1:0] mem_byte_enable_mem;
/* Future stages */
logic regfilemux_sel_mem;
logic memread_sel_mem;
logic load_cc_mem;
//logic branch_enable_ex;
logic [2:0] destmux_out_mem;
logic [1:0] pcmux_sel_mem;
logic pcmux_sel_out_sel_mem;

/* MEM Output Signals */
logic [15:0] mem_wb;
logic load_regfile_mem;
logic [15:0] regfilemux_out_mem;
lc3b_mem_wmask mem_byte_enable_wb;

/* WB Control Signals */

logic load_cc_wb;
logic memread_sel_wb;
logic [1:0] pcmux_sel_wb;
logic [2:0] destmux_out_wb;
logic [15:0] regfilemux_out_wb;
logic [15:0] memreadmux_out_wb;
logic pcmux_sel_out_sel_wb;
logic load_regfile_wb;

/* WB Outputs to IF stage which is buffered by PC register*/
/* WB Internal Signals */
logic [15:0] byte_sel_out;
logic [2:0] gencc_out;
logic [2:0] cc_out;
logic branch_enable_wb;

/* Pass Through Signals */
//logic [3:0] opcode_id;
lc3b_opcode opcode_ex;
lc3b_opcode opcode_mem;
lc3b_opcode opcode_wb;

logic [15:0] pc_id;
logic [15:0] pc_ex;
logic [15:0] pc_mem;
logic [15:0] pc_wb;

logic [2:0] dest_ex;

logic [15:0] alu_out_wb;

/**********IF stage***************/

assign load_pc = ~stall_I & ~stall_D;



/* Modules */
mux4 pcmux
(
    .sel(pcmux_sel_out),
    .a(pc_plus2_out),
    .b(alu_out_wb),
    .c(sr1_out_id), 
	.d(mem_wb),
	.f(pcmux_out)
);

register pc
(
	.clk,
	.reset,
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out)
);

plus2 #(.width(16)) pcplus2
(
	.in(pc_out),
	.out(pc_plus2_out) 
);


/* I-Cache Interface */
	/* Stall Register update untill completed memory read from I-Cache */
stall STALLI
(
	.read(I_mem_read),
	.write(1'b0),
	.resp(I_mem_resp),
	.stall(stall_I)
);


	 /* I_Cache signals */
assign I_mem_address = pc_out;
assign I_mem_read = ~I_mem_resp & ~stall_D;

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		pc_id <= 0;
		ir_id <= 0;
	end
	else if (!stall_I & !stall_D) begin
		ir_id <= I_mem_rdata;
		pc_id <= pc_plus2_out; 
	end

	
	
end

/**************************************/

/**********ID stage***************/
/* Modules */
assign trapvect_id = {7'b0, ir_id[7:0], 1'b0};
assign dest_id = ir_id[11:9];
assign opcode_id = lc3b_opcode'(ir_id[15:12]);

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
    .in(memreadmux_out_wb),
    .src_a(sr1mux_out),
    .src_b(sr2mux_out),
    .dest(destmux_out_wb),
    .reg_a(sr1_out_id),
    .reg_b(sr2_out_id)
);

mux2 #(.width(16)) ADJ6MUX
(
    .sel(sh6_sel_id),
    .a({{10{ir_id[5]}}, ir_id[5:0]}),
    .b({{9{ir_id[5]}}, ir_id[5:0], 1'b0}),
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
    .memread_sel(memread_sel_id),
    .load_cc(load_cc_id),
    .destmux_sel(destmux_sel_id),
    .pcmux_sel(pcmux_sel_id),
    .pcmux_sel_out_sel(pcmux_sel_out_sel_id)
);

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
        sr1id_ex <= 0;
        sr2id_ex <= 0;
        alumux1_sel_ex <= 0;
        alumux2_sel_ex <= 0;
        aluop_ex <= alu_pass;
        indirect_ex <= 0;
        mem_byte_enable_ex <= 0;
        regfilemux_sel_ex <= 0;
        memread_sel_ex <= 0;
        load_cc_ex <= 0;
        //branch_enable_ex <= 0;
        destmux_sel_ex <= 0;
        pcmux_sel_ex <= 0;
		  dest_ex <= 0;
		  mem_read_ex <= 0;
		  mem_write_ex <= 0;
		  load_regfile_ex <= 0;
	end
	else if (!stall_D) begin
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
        sr1id_ex <= sr1mux_out;
        sr2id_ex <= sr2mux_out;
        alumux1_sel_ex <= alumux1_sel_id;
        alumux2_sel_ex <= alumux2_sel_id;
        aluop_ex <= aluop_id;
        indirect_ex <= indirect_id;
        mem_byte_enable_ex <= mem_byte_enable_id;
        regfilemux_sel_ex <= regfilemux_sel_id;
        memread_sel_ex <= memread_sel_id;
        load_cc_ex <= load_cc_id;
        /* branch_enable_ex <= branch_enable_id; */ // Not needed?
        destmux_sel_ex <= destmux_sel_id;
        pcmux_sel_ex <= pcmux_sel_id;
		  pcmux_sel_out_sel_ex <= pcmux_sel_out_sel_id;
		  dest_ex <= dest_id;
		  mem_read_ex <= mem_read_id;
		  mem_write_ex <= mem_write_id;
		  dest_ex <= dest_id;
		  load_regfile_ex <= load_regfile_id;
	end	
end
/**************************************/

/************* EX State *************/
/* Modules */
mux4 FWDMUX1
(
    .sel(fwd1_sel),
    .a(sr1_ex),
    .b(regfilemux_out_mem),
    .c(memreadmux_out_wb),
    .d(),
    .f(fwdmux1_out)
);

mux4 FWDMUX2
(
    .sel(fwd2_sel),
    .a(sr2_ex),
    .b(regfilemux_out_mem),
    .c(memreadmux_out_wb),
    .d(),
    .f(fwdmux2_out)
);

mux4 #(.width(16)) ALUMUX1
(
    .sel(alumux1_sel_ex),
    .a(fwdmux1_out),
    .b(adj9_out_ex),
	.c(adj11_out_ex),
	.d(trapvect_ex),
    .f(alumux1_out)
);

mux4 #(.width(16)) ALUMUX2
(
    .sel(alumux2_sel_ex),
    .a(fwdmux2_out),
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

mux2 #(.width(3)) destmux
(
	.sel(destmux_sel_ex),
	.a(dest_ex),
	.b(3'b111),
	.f(destmux_out_ex)
);

hazard HDETECTOR
(
    .sr1(sr1id_ex),
    .sr2(sr2id_ex),
    .destmux_out_mem(destmux_out_mem),
    .destmux_out_wb(destmux_out_wb),
    .regfilemux_out_mem(regfilemux_out_mem),
    .memreadmux_out_wb(memreadmux_out_wb),
    .mem_read_mem(mem_read_mem)
);

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		alu_out_mem <= 0;
		sr2_mem <= 0;
       indirect_mem <= 0;
		 load_regfile_mem <= 0;
	end
	else if (!stall_D) begin
		pc_mem <= pc_ex;
		alu_out_mem <= alu_out;
		sr2_mem <= sr2_ex;
		/* control signal assignments */
		indirect_mem <= indirect_ex;
		mem_read_mem <= mem_read_ex;
		mem_write_mem <= mem_write_ex;
		mem_byte_enable_mem <= mem_byte_enable_ex;
		regfilemux_sel_mem <= regfilemux_sel_ex;
        memread_sel_mem <= memread_sel_ex;
		load_cc_mem <= load_cc_ex;
		//branch_enable_mem <= branch_enable_ex;
		destmux_out_mem <= destmux_out_ex;
		pcmux_sel_mem <= pcmux_sel_ex;
		pcmux_sel_out_sel_mem <= pcmux_sel_out_sel_ex;
		opcode_mem <= opcode_ex;
		load_regfile_mem <= load_regfile_ex;
	end	
end
/**************************/

/****** MEM stage ***********/
/* Modules */

/* D-Cache Interface */
/* Stall Register update untill completed memory read from D-Cache */
stall STALLD
(
	.read(P_mem_read),
	.write(P_mem_write),
	.resp(P_mem_resp),
	.stall(stall_D)
);
assign P_mem_address = alu_out_mem;
assign P_mem_wdata = sr2_mem;
assign P_mem_read = mem_read_mem;
assign P_mem_write = mem_write_mem;
assign P_mem_byte_enable = mem_byte_enable_mem;  // change when Dcache Interfacae implemented
assign indirect = indirect_mem & !P_mem_resp;

mux2 regfilemux
(
    .sel(regfilemux_sel_mem),
    .a(alu_out_mem),
    .b(pc_mem),
    .f(regfilemux_out_mem)
);

/* Update Registers */
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		alu_out_wb <= 0;
		pc_wb <= 0;
		mem_wb <= 0;
		opcode_wb <= op_br;
	end
	else if(!stall_D) begin
		alu_out_wb <= alu_out_mem;
		pc_wb <= pc_mem;
		mem_wb <= P_mem_rdata;
		mem_byte_enable_wb <= mem_byte_enable_mem;
		opcode_wb <= opcode_mem;
		
	  load_cc_wb <= load_cc_mem;
	  //branch_enable_mem <= branch_enable_ex;
	  destmux_out_wb <= destmux_out_mem;
	  pcmux_sel_wb <= pcmux_sel_mem;
	  pcmux_sel_out_sel_wb <= pcmux_sel_out_sel_mem;
	  load_regfile_wb <= load_regfile_mem;
      regfilemux_out_wb <= regfilemux_out_mem;
      memread_sel_wb <= memread_sel_mem;
	end	
end

/**************************************/


/******** WB stage ********/
/* Modules */
mux2 memreadmux
(
    .sel(memread_sel_wb),
    .a(regfilemux_out_wb),
    .b(mem_wb),
    .f(memreadmux_out_wb)
);

gencc gencc
(
	.in(memreadmux_out_wb),
	.out(gencc_out)
);

register #(.width(3)) cc	// Added CC width 
(
	.clk,
	.reset,
	.load(load_cc_wb),
	.in(gencc_out),
	.out(cc_out)
);

cccomp CCCOMP
(
	.nzp(destmux_out_wb),
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

endmodule : datapath
