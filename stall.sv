module stall
(
    input reset,
	input read,
	input write,
	input resp,
	output logic stall	 
);

always_ff @(posedge read or posedge write or posedge resp or posedge reset)
begin
	
    if(reset) begin
        stall <= 1'b0;
    end
	else if(resp)
    begin
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

endmodule : stall
