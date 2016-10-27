module stall
(
	input read,
	input write,
	input resp,
	output logic stall	 
);

initial
begin
    stall <= 1'b0;
end

always_ff @(posedge read or posedge write or posedge resp)
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

endmodule : stall
