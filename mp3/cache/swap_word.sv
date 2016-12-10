import lc3b_types::*;

module swap_word #(data_words = 16, log_word = 4)
(
	input lc3b_block data_out,
	output logic [15:0] out_word,
	input [15:0] swap_word,
	input [log_word-1:0] word_offset,
	output lc3b_block swap_data,
	input [1:0] mem_byte_enable
);


logic [15:0] internal_word_track;
always_comb begin
swap_data = 'z;
out_word = 'z;
internal_word_track = 'z;
	for(int i = 0; i < data_words; i++) begin
	  if(word_offset == i) begin
			internal_word_track[15:0] = data_out[16*(i+1)-1 -: 16];
			case(mem_byte_enable)
				2'b00 :	begin
						swap_data[16*(i+1)-1 -: 16] = data_out[16*(i+1)-1 -: 16];
					end
							
				2'b01 :	begin
						swap_data[(16*i)+7 -: 8] = swap_word[7:0];
						swap_data[16*(i+1)-1 -: 8] = data_out[16*(i+1)-1 -: 8];
					end

				2'b10 :	begin
						swap_data[(16*i)+7 -: 8] = data_out[(16*i)+7 -: 8];
						swap_data[16*(i+1)-1 -: 8] = swap_word[7:0];
					end

				2'b11 :	begin
						swap_data[16*(i+1)-1 -: 16] = swap_word[15:0];
					end
			endcase
		end
		else begin
			swap_data[16*(i+1)-1 -: 16] = data_out[16*(i+1)-1 -: 16];
		end
	end
	
	case(mem_byte_enable)
		2'b00 :	out_word = 16'b0;
		2'b01 :	out_word = {8'b0,internal_word_track[7:0]};
		2'b10 :	out_word = {8'b0,internal_word_track[15:8]};
		2'b11 :	out_word = internal_word_track;
	endcase
end
endmodule : swap_word
