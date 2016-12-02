module cache_control_i
(
    /* Input and output port declarations */

    input clk,
	 input reset,
	/* Datapath controls */
	output logic pmem_read,
	input mem_read,
	input hit,
	input pmem_resp,
	output logic mem_resp,
	output logic sel_way_mux
);

enum int unsigned {
    /* List of states */
	 check,
    allocate
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
    pmem_read = 1'b0;
	mem_resp = 0;
	sel_way_mux = 0;

	case(state)
		check: begin
			if(hit)
				mem_resp = 1;
			else
				mem_resp = 0;
		end
		
		allocate: begin
			/* Read memory */
			pmem_read = 1'b1;
			sel_way_mux = 1;
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
				if ( !hit && (mem_read))
					next_state <= allocate;
				else
					next_state <= check;
		  end
		  
        allocate : begin
		if(pmem_resp)
			next_state <= check;
        	else 
        		next_state <= allocate;
        end
		  
		default : ;

	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control_i
