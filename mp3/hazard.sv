import lc3b_types::*;

module hazard
(
    input [2:0] sr1,
    input [2:0] sr2,
    input [2:0] destmux_out_mem,
    input [2:0] destmux_out_wb,
    input lc3b_word regfilemux_out_mem,
    input lc3b_word memreadmux_out_wb,
    input mem_read_mem,
    output logic fwd1_sel,
    output logic fwd2_sel,
    output logic stall
);

endmodule : hazard
