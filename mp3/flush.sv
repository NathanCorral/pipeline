import lc3b_types::*;

module flush
(
	input [1:0] pcmux_sel_out,
	output logic flush_all	
);


always_comb
begin
	if(pcmux_sel_out != 0)
		flush_all = 1;
	else
		flush_all = 0;
end


endmodule : flush
