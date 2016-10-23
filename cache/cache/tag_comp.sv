module tag_comp #(parameter width = 9)
(
	input [width-1:0] tagfromcache,
	input [width-1:0] tagfrommem,
	output logic out
);

always_comb
begin 
		if(tagfromcache == tagfrommem)
		out = 1;
		
		else
		out = 0;
end

endmodule : tag_comp