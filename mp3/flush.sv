import lc3b_types::*;

module flush
(
	input [1:0] pcmux_sel_out,
	output logic flush_all	
);

// check me on this one, but I believe the formula for calculating
// when misprediction has occurred is that if pcmux_out is not
// equal to taken_pc_wb and predict_taken_wb is 1, a misprediction
// has occurred. OR if predict_taken_wb is 0 and pcmux_sel_out is
// non-zero, a misprediction has occurred. Think about these
// conditions very carefully, it's pretty subtle (I thought
// about it for probably half an hour before I was confident).
// In addition, if a branch was taken incorrectly, the PC
// register needs to load in PC+2_wb, and if a branch was
// correctly taken, PC register needs to load in the normal PC+2
// value, not the "actual" branch value that would normally be
// taken (resulting in instructions getting flushed out). So
// essentially on branch instructions, the pc register will be
// choosing between 1) the normal pc+2 value, or 2) the pc+2 value
// coming from the wb stage. We'll need to add another mux or two
// to the datapath to make this happen.
always_comb
begin
	if(pcmux_sel_out != 0)
		flush_all = 1;
	else
		flush_all = 0;
end


endmodule : flush
