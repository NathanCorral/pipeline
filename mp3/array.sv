import lc3b_types::*;

module array #(parameter width = 2, parameter index_bits = 5)
(
    input clk,
    input write,
    input [index_bits-1:0] read1_index,
    input [index_bits-1:0] read2_index,
    input [index_bits-1:0] write_index,
    input [width-1:0] datain,
    output logic [width-1:0] data1_out,
	output logic [width-1:0] data2_out
);

localparam size = 2 ** index_bits;

logic [width-1:0] data [size-1:0];

/* Initialize array */

initial

begin

    for (int i = 0; i < $size(data); i++)

    begin

        data[i] = 2'b01;

    end

end

always_ff @(posedge clk)

begin

    if (write == 1)

    begin

        data[write_index] = datain;

    end

end

assign data1_out = data[read1_index];
assign data2_out = data[read2_index];

endmodule : array
