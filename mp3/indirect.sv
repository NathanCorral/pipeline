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
    i1
} state, next_state;
logic finished_indirect, finished_indirect_next;
lc3b_word addr, addr_next;
always_comb
begin
	case (state)
		default : begin
				addr_next = addr;
		end
		idle : begin
				P_mem_resp = D_mem_resp & !(indirect & !finished_indirect);
				D_mem_read = P_mem_read | indirect;
				D_mem_write = P_mem_write & !indirect;
				D_mem_address = P_mem_address;
				D_mem_wdata = P_mem_wdata;
				P_mem_rdata = D_mem_rdata;
				addr_next = D_mem_rdata;
				mem_byte_enable = P_mem_byte_enable;
				finished_indirect_next = 0;
				if(D_mem_resp & indirect)
					next_state <= i1;
				else
					next_state <= idle;
		end
		i1 : begin
				P_mem_resp = D_mem_resp;
				D_mem_read = P_mem_read;
				D_mem_write = P_mem_write;
				D_mem_address = addr;
				addr_next = addr;
				D_mem_wdata = P_mem_wdata;
				P_mem_rdata = D_mem_rdata;
				mem_byte_enable = P_mem_byte_enable;
				finished_indirect_next = 1;
				if(D_mem_resp)
					next_state <= idle;
				else
					next_state <= i1;
		end

	endcase
end
always_ff @(posedge clk)
begin
	state <= next_state;
	finished_indirect <= finished_indirect_next;
	addr <= addr_next;
end

endmodule : indirect
