import lc3b_types::*;

module decode
(
	input [15:0] instruction,
	/* IF Control */
	output logic load_pc,
	/* ID Control */
	output logic adj9_sel,
	output logic adj11_sel,
	output logic sr1_sel,
	output logic sr2_sel,
	output logic sh6_sel,
	output logic imm_sel,
	/* EX Control */
	output logic [1:0] alumux1_sel,
	output logic [1:0] alumux2_sel,
	output lc3b_aluop alu_ctrl,
	/* MEM Control */
	output logic indirect,
	output logic read,
	output logic write,
	output logic mem_byte_sig,
	/* WB Control */
	output logic load_regfile,
	output logic [1:0] regfile_mux_sel,
	output logic load_cc,
	output logic destmux_sel,
	output logic [1:0] pcmux_sel	 
);

lc3b_opcode opcode;
logic ir5;

assign opcode = instruction[15:12];
assign ir5 = instruction[5];

always_comb
begin
	/* Always assigned signals */
	
	load_pc = 1;
	adj9_sel = 1;
	adj11_sel = 1;
	/* Default outputs */
	/* ID */
	sr1_sel = 0;
	sr2_sel = 0;
	sh6_sel = 0;
	imm_sel = 0;
	
	/* EX */
	alumux1_sel = 0;
	alumux2_sel = 0;
	alu_ctrl = alu_pass;
	
	/* MEM */
	indirect = 0;
	read = 0;
	write = 0;
	mem_byte_sig = 0;
	
	/* WB */
	regfile_mux_sel = 0;
	load_cc = 0;
	destmux_sel = 0;
	pcmux_sel = 0;
	
    case (opcode)
		op_add : begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'b0;
			sh6_sel = 1'bz;
			imm_sel = 1'b0;
			
			/* EX */
			alumux1_sel = 2'b00;
			if(ir5)
				alumux2_sel = /*I[5]*/ 2'b11;
			else
				alumux2_sel = /*I[5]*/ 2'b00;
			alu_ctrl = alu_add;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			
			/* WB */
			regfile_mux_sel = 2'b10;
			load_cc = 1;
			destmux_sel = 0;
			pcmux_sel = 2'b00;
		end

    endcase
end

endmodule : decode
