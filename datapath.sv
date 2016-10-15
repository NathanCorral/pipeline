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

logic [15:0] pc_ex;
logic [15:0] pc_mem;
/* 
/***** Pass Siganls Through *****/
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		pc_mem <= 0;
		opcode_mem <= 0;
	end
	else begin
		pc_mem <= pc_ex;
		opcode_mem <= opcode_ex;
	end	
end

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




/* MEM Control Signals */
/* MEM Input Signals */
logic [15:0] alu_out_mem;
logic [15:0] sr2_mem;

/* MEM Output Signals */



/************* EX State *************/
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





endmodule : datapath
