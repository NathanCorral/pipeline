module cache_control
(
    /* Input and output port declarations */

    input clk,
	 input reset,
	/* Datapath controls */
	output logic sel_way_mux,
	output logic pmem_mux_sel,
	output logic pmem_read,
	output logic pmem_write,
	input mem_read,
	input mem_write,
	input hit,
	input dirty,
	input pmem_resp,
	output logic mem_resp
);

enum int unsigned {
    /* List of states */
	 check,
    write_back,
    allocate
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
	 sel_way_mux = 1'b0;
    pmem_mux_sel = 1'b0;
    pmem_read = 1'b0;
    pmem_write = 1'b0;
	mem_resp = 0;

	case(state)
		check: begin
			if(hit)
				mem_resp = 1;
			else
				mem_resp = 0;
		end
		
		write_back: begin
			/* MAR <= PC */
			sel_way_mux = 1'b1;
			pmem_mux_sel = 1'b1;
			pmem_write = 1'b1;
		end

		allocate: begin
			/* Read memory */
			sel_way_mux = 1'b1;
			pmem_read = 1'b1;
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
				if( !hit && dirty && (mem_read | mem_write))
					next_state <= write_back;
				else if ( !hit && !dirty && (mem_read | mem_write))
					next_state <= allocate;
				else
					next_state <= check;
		  end
		  
        write_back : begin
        	if(pmem_resp) 
        		next_state <= allocate;
        	else 
        		next_state <= write_back;
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

endmodule : cache_control
