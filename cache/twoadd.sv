import lc3b_types::*;


module twoadd
(
	input lc3b_word a,
	input lc3b_word b,
	output lc3b_word out
);

always_comb
begin
	out = a + b;
end
endmodule: twoadd