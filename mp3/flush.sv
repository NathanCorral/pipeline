import lc3b_types::*;

module flush
(
	input pcmux_sel_out,
	output flush_all	
);


always_comb
begin
	if(pcmux_sel_out != 0)
		flush_all = 1;
	else
		flush_all = 0;
end


endmodule : flush
