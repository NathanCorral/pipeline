import lc3b_types::*;


module cccomp
(
	input lc3b_reg nzp,
	input lc3b_nzp cc,
	output logic branch_enable
);
always_comb
begin
	if( (cc[0] & nzp[0]) | (cc[1] & nzp[1]) | (cc[2] & nzp[2]))
		branch_enable = 1;
	else 
		branch_enable = 0;
end 
endmodule : cccomp