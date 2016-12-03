module cache_control_pre
(
    /* Input and output port declarations */

    input clk,
	 input reset,

	input pmem_resp,
	input I_resp,
	input D_resp,
	input l2_pmem_read,
	input pmem_write,
	
	input hit,
	output logic pmem_read,
	output logic pre_resp,
	output logic l2_resp_sel,
	output logic l2_rdata_sel,
	output logic pmem_address_sel,
	output logic load_pre,
	output logic wait_l2
);

enum int unsigned {
    /* List of states */
	 check,
   prefetch,
	allocate
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
    pmem_read = 1'b0;
	pre_resp = 0;
	l2_resp_sel = 0;
	l2_rdata_sel = 0;
	pmem_address_sel = 0;
	load_pre = 0;
	wait_l2 = 0;

	case(state)
		check: begin
			if(hit & !pmem_write)
				pre_resp = 1;
			else
				pre_resp = 0;
		end
		
		prefetch : begin
			/* Read memory */
			pmem_read = !hit;
			pmem_address_sel = 1;
			pre_resp = 0;
			wait_l2 = 1;
			load_pre = 1;
		end

		allocate: begin
			/* Read memory */
			pmem_read = 1'b1;
			l2_rdata_sel = 1'b1;
			l2_resp_sel = 1;
		end
		
		default: /* Do nothing */;

	endcase

end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
     next_state  = state;
     unique case (state)		 
		  check : begin
				if (I_resp)
					next_state <= prefetch;
				else if (l2_pmem_read & !hit)
					next_state <= allocate;
				else
					next_state <= check;
		  end
		  
	        allocate : begin
				if(D_resp)
					next_state <= check;
				else if(I_resp)
					next_state <= prefetch;  
		        	else 
        				next_state <= allocate;
      		  end

		  prefetch : begin
				if (pmem_resp | hit)
					next_state <= check;
				else 
					next_state <= prefetch;
		  end
		  
		default : ;

	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control_pre
