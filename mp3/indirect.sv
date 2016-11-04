import lc3b_types::*;

module indirect
(
	input clk,

	output logic P_mem_resp,
	input P_mem_read,
	input P_mem_write,
	input lc3b_word P_mem_address,
	input lc3b_word P_mem_wdata,
	output lc3b_word P_mem_rdata,
	input lc3b_mem_wmask P_mem_byte_enable,
	input logic indirect,
	
	input logic D_mem_resp,
	output logic D_mem_read,
	output logic D_mem_write,
	output lc3b_word D_mem_address,
	output lc3b_word D_mem_wdata,
	input   lc3b_word D_mem_rdata,
	output lc3b_mem_wmask mem_byte_enable	
);

/* Reset Control */
enum int unsigned {
	 idle,
    i1,
	 i2
} state, next_state;
always_comb
begin
	case (state)
		idle : begin
				P_mem_resp = D_mem_resp;
				D_mem_read = P_mem_read;
				D_mem_write = P_mem_write;
				D_mem_address = P_mem_address;
				D_mem_wdata = P_mem_wdata;
				P_mem_rdata = D_mem_rdata;
				mem_byte_enable = P_mem_byte_enable;
				if((P_mem_read | P_mem_write) & indirect)
					next_state <= i1;
				else
					next_state <= idle;
		end
		i1 : begin
				P_mem_resp = 0;
				D_mem_read = 1;
				D_mem_write = 0;
				D_mem_address = P_mem_address;
				D_mem_wdata = P_mem_wdata;
				P_mem_rdata = D_mem_rdata;
				mem_byte_enable = P_mem_byte_enable;
				if(D_mem_resp)
					next_state <= i2;
				else
					next_state <= i1;
		end
		i2 : begin
				P_mem_resp = D_mem_resp;
				D_mem_read = P_mem_read;
				D_mem_write = P_mem_write;
				D_mem_address = D_mem_rdata;
				D_mem_wdata = P_mem_wdata;
				P_mem_rdata = D_mem_rdata;
				mem_byte_enable = P_mem_byte_enable;
				if(D_mem_resp)
					next_state <= idle;
				else
					next_state <= i2;
		end
	endcase
end
always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : indirect
