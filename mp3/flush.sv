import lc3b_types::*;

module flush
(
    input [1:0] pcmux_sel_out,
    input lc3b_word pcmux_out,
    input lc3b_word taken_pc_wb,
    input predict_taken_wb,
    output logic flush_all,
    output logic [1:0] flushmux_sel
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

// predict_taken_wb     pcmux_sel_out   taken_pc_wb == pcmux_out    next_pc flush
//                0                 0                          0       pc+2     0 (in these two cases pc+2 is equal to pcmux_out since
//                0                 0                          1       pc+2     0  pcmux_sel_out is 0)
//                0                 1                          0  pcmux_out     1
//                0                 1                          1  pcmux_out     1 (I think we could set flush = 0 and next_pc = pc+2 here,
//                                                                                 but I'm not even sure if this case can happen and this
//                                                                                 is safer I think)
//                1                 0                          0      pc_wb     1
//                1                 0                          1      pc_wb     1 (similar situation to above comment)
//                1                 1                          0  pcmux_out     1
//                1                 1                          1       pc+2     0
logic ptw;
logic pso;
logic tep;

assign ptw = predict_taken_wb;
assign pso = pcmux_sel_out != 2'b00;
assign tep = taken_pc_wb == pcmux_out;
assign flush_all = (ptw & pso & tep) | (~ptw & ~pso & ~tep) | (~ptw & ~pso & tep);
assign flushmux_sel[0] = ptw & pso;
assign flushmux_sel[1] = flush_all;

endmodule : flush
