import lc3b_types::*;

module branch_predictor #(parameter hist_reg_width = 4, parameter index_bits = 5)
(
    input clk,
    input reset,
    input lc3b_word PC_if,
    input lc3b_word PC_wb,
    input [1:0] pcmux_sel_out,
    input is_valid_inst_wb,
    input lc3b_opcode opcode_wb,
    input enable,
    input [hist_reg_width-1:0] branch_hist_wb,
    output logic predict_taken,
    output logic [hist_reg_width-1:0] branch_hist_if
);

// branch_hist_reg related signals
logic [hist_reg_width-1:0] branch_hist_reg_out;
logic wr_enable;
logic taken_wb;

assign taken_wb = pcmux_sel_out != 2'b0;
assign wr_enable = enable & (opcode_wb == op_br & is_valid_inst_wb);

// predictor array signals
logic [index_bits-1:0] r1_idx;
logic [index_bits-1:0] rw_idx;
logic [1:0] r1data_out;
logic [1:0] r2data_out;
logic [1:0] wr_data;

assign r1_idx = {PC_if[index_bits:index_bits-hist_reg_width+1] ^ branch_hist_reg_out, PC_if[index_bits-hist_reg_width:1]};
assign rw_idx = {PC_wb[index_bits:index_bits-hist_reg_width+1] ^ branch_hist_wb, PC_wb[index_bits-hist_reg_width:1]};
// truth table for wr_data:
// ReadData    Taken   WriteData
// 00          0       00
// 00          1       01
// 01          0       00
// 01          1       10
// 10          0       01
// 10          1       11
// 11          0       10
// 11          1       11
assign wr_data[0] = (r2data_out == 2'b10) | (r2data_out == 2'b11 & taken_wb) | (r2data_out == 2'b00 & taken_wb);
assign wr_data[1] = (r2data_out == 2'b11) | (r2data_out == 2'b10 & taken_wb) | (r2data_out == 2'b01 & taken_wb);

register #(.width(hist_reg_width)) branch_hist_reg
(
    .clk(clk),
    .reset(reset),
    .load(wr_enable),
    .in({branch_hist_reg_out[hist_reg_width-2:0], taken_wb}),
    .out(branch_hist_reg_out)
);

// 2 bit saturating counters seems good, width experimentation might
// get a bit messy if I don't figure out a nice way to increment
// and decrement the counters though
// TODO: initialize array counters to weakly not taken
array #(.width(2), .index_bits(index_bits)) counters
(
    .clk(clk),
    .write(wr_enable),
    .read1_index(r1_idx),
    .read2_index(rw_idx),
    .write_index(rw_idx),
    .datain(wr_data),
    .data1_out(r1data_out),
    .data2_out(r2data_out)
);

assign predict_taken = r1data_out[1];
assign branch_hist_if = branch_hist_reg_out;

endmodule : branch_predictor
