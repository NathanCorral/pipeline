import lc3b_types::*;

module word_mux #(data_words = 8, log_word = 3)
(
	input lc3b_block data_out,
	output logic [15:0] out_word,
	input [log_word-1 :0] word_offset
);


always_comb begin
out_word = 16'b0;
	for(int i=0; i < data_words; i++) begin
		if(word_offset == i) begin
			for(int d=0; d<16; d++) begin
				out_word[d] = data_out[16*i + d];
			end
			break;
		end
	end
end
endmodule : word_mux
