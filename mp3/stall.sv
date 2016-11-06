module stall
(
	input read,
	input write,
	input resp,
	output logic stall	 
);
/*
initial
begin
    stall <= 1'b0;
end

logic hack;

assign hack = ~resp;
*/
assign stall = (read | write) & ~resp;

/*
always_ff @(posedge read or posedge write or posedge resp or posedge hack)
begin
	
	if(resp) begin
		stall <= 1'b0;
	end	
	else if((read | write))
	begin
		stall <= 1'b1;
	end
	else begin
		stall <= stall;
	end
end
*/
/*
enum int unsigned {
	 normal,
    stop
} state, next_state;
always_comb
begin
	case (state)
		normal : begin
				stall = 0;
				if((read | write))
					next_state <= stop;
				else
					next_state <= normal;
		end
		stop : begin
				stall = 1;
				if(resp)
					next_state <= normal;
				else
					next_state <= stop;
		end
	endcase
end
always_ff @(posedge read or posedge write or posedge resp)
begin
	state <= next_state;
end
*/

endmodule : stall
