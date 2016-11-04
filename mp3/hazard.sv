import lc3b_types::*;

module hazard
(
	 input clk,
    input [2:0] sr1,
    input [2:0] sr2,
    input [2:0] destmux_out_mem,
    input [2:0] destmux_out_wb,
    input mem_read_mem,
	 input load_regfile_mem,
	 input load_regfile_wb,
    output lc3b_forward fwd1_sel,
    output lc3b_forward fwd2_sel,
    output logic stall_load
);



always_comb 
begin
	if(load_regfile_mem & (sr1 == destmux_out_mem)) 
		begin
			fwd1_sel = ex_ex;
		end
	else if(load_regfile_wb & (sr1 == destmux_out_wb))
		begin
			fwd1_sel = mem_ex;
		end
	else
		begin
			fwd1_sel = none;
		end
		
	if(load_regfile_mem & (sr2 == destmux_out_mem)) 
		begin
			fwd2_sel = ex_ex;
		end
	else if(load_regfile_wb & (sr2 == destmux_out_wb))
		begin
			fwd2_sel = mem_ex;
		end
	else
		begin
			fwd2_sel = none;
		end
	
end


enum int unsigned {
	 normal,
    stall
} state, next_state;
always_comb
begin
	case (state)
		normal : begin
				stall_load = 0;
				if(((sr1 == destmux_out_mem) | (sr2 == destmux_out_mem)) && (mem_read_mem))
					next_state <= stall;
				else
					next_state <= normal;
		end
		stall : begin
				stall_load = 1;
				next_state <= normal;
		end
	endcase
end
always_ff @(posedge clk)
begin
	state <= next_state;
end

			
		

endmodule : hazard
