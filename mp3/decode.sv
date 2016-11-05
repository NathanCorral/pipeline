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
   output logic regfilemux_sel,
	/* WB Control */
	output logic load_regfile,
   output logic memread_sel,
	output logic load_cc,
	output logic destmux_sel,
	output logic [1:0] pcmux_sel,
	output logic pcmux_sel_out_sel
);

lc3b_opcode opcode;
logic ir5;
logic ir4;
logic ir11;

assign opcode = lc3b_opcode'(instruction[15:12]);
assign ir5 = instruction[5];
assign ir4 = instruction[4];
assign ir11 = instruction[11];

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
			destmux_sel = 0;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			 regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1; 
			load_cc = 1;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
			memread_sel = 1'b0;
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
			destmux_sel = 0;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1;
			load_cc = 1;
			memread_sel = 1'b0;
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
			destmux_sel = 0;			

			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1; 
			load_cc = 1;
			memread_sel = 1'b0;
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
			destmux_sel = 0;
			
			/* MEM */
			indirect = 1'b0;
			read = 1;
			write = 0;
			mem_byte_sig = 2'b11;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1; 	
			load_cc = 1;
			memread_sel = 1'b1;
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
			destmux_sel = 1'bz;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 1;
			mem_byte_sig = 2'b11;
			regfilemux_sel = 1'bz;
			
			/* WB */
			load_regfile = 0; 
			load_cc = 0;
			memread_sel = 1'bz;
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
			destmux_sel = 1'b0;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 0;
			load_cc = 0;
			memread_sel = 1'b0;
			pcmux_sel = 2'bzz;
			pcmux_sel_out_sel = 1;
		end
		
		op_jmp: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'bzz;
			alu_ctrl = alu_pass;
			destmux_sel = 1'bz;
			
			/* MEM */
			indirect = 1'bz;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'bz;
			
			/* WB */
			load_regfile = 0;
			load_cc = 0;
			memread_sel = 1'bz;
			pcmux_sel = 2'b01;
			pcmux_sel_out_sel = 0;
		end
		
		op_jsr: begin
			/* ID */
			sr1_sel = 1'bz;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			if(ir11 != 0)
			begin
				alumux1_sel = 2'b10;
				alumux2_sel = 2'b10;
				alu_ctrl = alu_add;
			end 
			else
			begin
				alumux1_sel = 2'b00;
				alumux2_sel = 2'bzz;
				alu_ctrl = alu_pass;
			end
			destmux_sel = 1'b1;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b1;
			
			/* WB */
			load_regfile = 1;
			load_cc = 0;
			memread_sel = 1'b0;
			pcmux_sel = 2'b01;
			pcmux_sel_out_sel = 0;
		end
		


		op_ldb: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'b0; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			destmux_sel = 1'b0;
			
			/* MEM */
			indirect = 1'b0;
			read = 1;
			write = 0;
			mem_byte_sig = 1;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1;
			load_cc = 1;
			memread_sel = 1'b1;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end		
		
		op_ldi: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'b1; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			destmux_sel = 1'b0;
			
			/* MEM */
			indirect = 1'b1;
			read = 1;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1;
			load_cc = 1;
			memread_sel = 1'b1;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end		
		
		
		op_lea: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b10;
			alu_ctrl = alu_add;
			destmux_sel = 1'b0;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1;
			load_cc = 1;
			memread_sel = 1'b0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end		
		
		op_shf: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'b1;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'bzz;
			if(ir4 == 0)
			begin
				alu_ctrl = alu_sll;
			end 
			else
			begin
				if(ir5 == 0)
				alu_ctrl = alu_srl; //DR = SR >> IMM4,0
				else
				alu_ctrl = alu_srl; //DR = SR >> IMM4, SR[15]
			end
			destmux_sel = 1'b0;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b0;
			
			/* WB */
			load_regfile = 1;
			load_cc = 1;
			memread_sel = 1'b0;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end		

		op_stb: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'b1;
			sh6_sel = 1'b0; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			destmux_sel = 1'bz;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 1;
			mem_byte_sig = 1;
			regfilemux_sel = 1'bz;
			
			/* WB */
			load_regfile = 0;
			load_cc = 0;
			memread_sel = 1'bz;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end	
	
		op_sti: begin
			/* ID */
			sr1_sel = 1'b0;
			sr2_sel = 1'b1;
			sh6_sel = 1'b1; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b00;
			alumux2_sel = 2'b01;
			alu_ctrl = alu_add;
			destmux_sel = 1'bz;
			
			/* MEM */
			indirect = 1'b1;
			read = 0;
			write = 1;
			mem_byte_sig = 0;
			regfilemux_sel = 1'bz;
			
			/* WB */
			load_regfile = 0;
			load_cc = 0;
			memread_sel = 1'bz;
			pcmux_sel = 2'b00;
			pcmux_sel_out_sel = 0;
		end		
	
		op_trap: begin
			/* ID */
			sr1_sel = 1'bz;
			sr2_sel = 1'bz;
			sh6_sel = 1'bz; 
			imm_sel = 1'bz;
			
			/* EX */
			alumux1_sel = 2'b11;
			alumux2_sel = 2'bzz;
			alu_ctrl = alu_pass;
			destmux_sel = 1'b1;
			
			/* MEM */
			indirect = 1'b0;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 1'b1;
			
			/* WB */
			load_regfile = 1;
			load_cc = 0;
			memread_sel = 1'b0;
			pcmux_sel = 2'b11;
			pcmux_sel_out_sel = 0;
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
			destmux_sel = 0;
			
			/* MEM */
			indirect = 0;
			read = 0;
			write = 0;
			mem_byte_sig = 0;
			regfilemux_sel = 0;
			
			/* WB */
			load_regfile = 0;		
			load_cc = 0;
			memread_sel = 0;
			pcmux_sel = 0;
			pcmux_sel_out_sel = 0;
		end
		
		
    endcase
end

endmodule : decode
