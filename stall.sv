module stall
(
	input read,
	input write,
	input resp,
	output logic stall	 
);

always_ff @(posedge read or posedge write or posedge resp)
begin
	
	if(resp) begin
		stall <= 0;
	end	
	else if((read | write))
	begin
		stall <= 1;
	end
	else begin
		stall <= stall;
	end
end

endmodule : stall
