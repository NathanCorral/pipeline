
module lru
(
	input integer way_sel,
	input logic hit,
	input [2:0] lru,
	output integer way_out,
	output [2:0] updata_lru
);

logic [2:0] temp;
assign temp = lru;

always_comb begin
	if(hit) begin
	end
	else if(!hit) begin
	end
end

endmodule: lru 
