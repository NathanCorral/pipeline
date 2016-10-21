module stall
(
	input read,
	input write,
	input resp,
	output logic stall	 
);

always_ff @(posedge read or posedge write or posedge resp)
begin
	if(read | write & !resp)
	begin
		stall <= 1;
	end
	else if(resp) begin
		stall <= 0;
	end	
	else begin
		stall <= stall;
	end
end

endmodule : stall
