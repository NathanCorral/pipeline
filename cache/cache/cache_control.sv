import lc3b_types::*;

module cache_control
(
	input clk,
	input logic hit,
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	
	/***write***/
	output logic lru_write, 
	output logic data0_write,data1_write, 
	output logic tag0_write,tag1_write,
	output logic valid0_write, valid1_write,
	output logic dirty0_write,dirty1_write,
	//input logic tag0_write, tag1_write,
	
	/***in***/
	output logic lru_in,
	output logic dirty0_in, dirty1_in,
	
	/***sel***/
	output logic pmemmux_sel,writein_sel,
	
	input logic way0_out, way1_out,
	output logic pmem_read, pmem_write,
	input logic pmem_resp,
	input lc3b_mem_wmask mem_byte_enable,
	
	input logic lru_out,
	input logic dirtymux_out,
	input logic dirty0_out,dirty1_out
	
);

enum int unsigned {	
	s_idle,
	s_writeback,
	s_allocate,
	s_lruupdata,
	s_writemiss
} state, next_state;


always_comb
begin: state_actions

	//initianize
	lru_write = 0;
	data0_write = 0;
	data1_write = 0;
	tag0_write = 0;
	tag1_write = 0;
	valid0_write = 0;
	valid1_write = 0;
	dirty0_write = 0;
	dirty1_write = 0;
	dirty0_in = 0;
	dirty1_in = 0;
	mem_resp = 0;
	writein_sel = 0;
	pmemmux_sel = 0;
	pmem_write = 0;
	pmem_read = 0;
	lru_in = 0;
	mem_resp = 0;

	



	case(state)
	  
			s_idle: begin
			
			if(hit && mem_read)
				begin
					mem_resp = 1;
					lru_write = 1;
					if(way0_out && hit)
					lru_in = 1;
					if(way1_out && hit)
					lru_in = 0;
				end
			else if((mem_write && hit) && (mem_byte_enable != 2'b00))
				begin
					lru_write = 1;
					mem_resp = 1;
					writein_sel = 1; //the data from mem_wdata
					if(way0_out)
						begin
							data0_write = 1;
							tag0_write = 1;
							valid0_write = 1;
							dirty0_write = 1;
							dirty0_in = 1;
							lru_in = 1;
						end
					
					if(way1_out)
						begin
							data1_write = 1;
							tag1_write = 1;
							valid1_write = 1;
							dirty1_write = 1;
							dirty1_in = 1;
							lru_in = 0;
						end					
				end
			end
			
			s_writeback:begin
				pmemmux_sel = 1; //address of {tag_out,index,4'b0000}
				pmem_write = 1;  
			end
			
			
			s_allocate:begin
				pmem_read = 1;
				if(mem_read)
				begin
				pmemmux_sel = 0; //address of mem_address
				end
				else if(mem_write)
				begin
				pmemmux_sel = 1; 
				end
				
				if(lru_out)
				begin
					data1_write = 1;
					tag1_write = 1;
					valid1_write = 1;
					dirty1_write = 1;
					dirty1_in = 0;
				end
				else
				begin
					data0_write = 1;
					tag0_write = 1;
					valid0_write = 1;
					dirty0_write = 1;
					dirty0_in = 0;
				end

				
			end
			
			s_writemiss:begin
			if(mem_write)
			 begin
			 writein_sel = 1; //data from wdata
			 if(lru_out)
				begin
					data1_write = 1;
					tag1_write = 1;
					valid1_write = 1;
					dirty1_write = 1;
					dirty1_in = 1;
				end
				else
				begin
					data0_write = 1;
					tag0_write = 1;
					valid0_write = 1;
					dirty0_write = 1;
					dirty0_in = 1;
				end
			end
			end
			
			
			s_lruupdata:begin
			lru_write = 1;
			if(lru_out)
			lru_in = 0;
			else
			lru_in = 1;
			mem_resp = 1;
			end
			

			endcase
			
			
	
end

always_comb
begin : next_state_logic
	  next_state = state;
	  
	  case(state)
	  
			s_idle: begin
			
				if((!mem_read && !mem_write) || hit)
				next_state = s_idle;
				else if(!hit && ((lru_out && dirty1_out)||(!lru_out && dirty0_out)))
				next_state = s_writeback;
				else 
				next_state = s_allocate;
			
			
			end
			
			s_writeback:begin
			if(pmem_resp)
			next_state = s_allocate;
			else
			next_state = s_writeback;
	
			
			
			end
			
			
			s_allocate:begin
			if(pmem_resp)
			next_state = s_writemiss;
			else
			next_state = s_allocate;
			
			end
			
			s_lruupdata:begin
			next_state = s_idle;
			end
			
			s_writemiss:begin
			next_state = s_lruupdata;
			end

endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	  state <= next_state;
end

endmodule : cache_control
