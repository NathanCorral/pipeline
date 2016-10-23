import lc3b_types::*;

module decode
(
	input [15:0] instruction,
	/* ID Control */
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
	output logic [1:0] mem_byte_sig,
	/* WB Control */
	output logic load_regfile,
	output logic [1:0] regfilemux_sel,
	output logic load_cc,
	output logic destmux_sel,
	output logic [1:0] pcmux_sel,
	output logic pcmux_sel_out_sel
);

lc3b_opcode opcode;
logic ir5;

assign opcode = lc3b_opcode'(instruction[15:12]);
assign ir5 = instruction[5];

always_comb
begin	
			
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
			load_regfile = 1; 
 			regfilemux_sel = 2'b10;
			load_cc = 1;
			destmux_sel = 0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end

		op_and: begin
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
			alu_ctrl = alu_and;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			
			/* WB */
			load_regfile = 1; 
			regfilemux_sel = 2'b10;
			load_cc = 1;
			destmux_sel = 0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end
		
		op_not: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'bzz;
			alu_ctrl = alu_not;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			
			/* WB */
			load_regfile = 1; 
			regfilemux_sel = 2'b10;
			load_cc = 1;
			destmux_sel = 0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end
		
		op_ldr: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'b1; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			
			/* MEM */
			indirect = 1'b0;
			read = 1;
			write = 0;
			mem_byte_sig = 2'b11;
			
			/* WB */
			load_regfile = 1; 
			regfilemux_sel = 2'b00;
			load_cc = 1;
			destmux_sel = 0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end
		
		op_str: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'b1;
			sh6_sel = 1'b1; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 1;
			mem_byte_sig = 2'b11;
			
			/* WB */
			load_regfile = 0; 
			regfilemux_sel = 2'bzz;
			load_cc = 0;
			destmux_sel = 1'bz;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end
		
		op_br: begin
			/* ID */
			sr1_sel = 1'bz;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b01;
			alumux2_sel = 2'b10;
			alu_ctrl = alu_add;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			
			/* WB */
			load_regfile = 0;
 			regfilemux_sel = 2'bzz;
			load_cc = 0;
			destmux_sel = 1'bz;
			pcmux_sel = 2'bzz;
			pcmux_sel_out_sel = 1;
		end
		
		default : begin
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
			load_regfile = 0;
			regfilemux_sel = 0;
			load_cc = 0;
			destmux_sel = 0;
			pcmux_sel = 0;
			pcmux_sel_out_sel = 0;
		end
		
		
    endcase
end

endmodule : decode
