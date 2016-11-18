module compare #(parameter width = 11)
(
	input [width-1:0] a,
	input [width-1:0] b,
	output logic out
);


always_comb begin
if(a == b)
 out = 1;
else
 out = 0;
end
endmodule : compare
