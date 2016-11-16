import lc3b_type::*;
module btb #(parameter way = 4, lines = 1024)
(
 input lc3b_word pc;
 output lc3b_word branch_address; 
);
logic [1:0]offset;
logic [9:0]index;
logic [19:0]tag;

/* pc */
assign offset = pc[1:0];
assign index = pc[11:2];
assign tag = pc[31:12];

/* array for address */
logic [31:0] br_address[lines][way]; //branch address
logic  LRU[lines][3];  //LRU
logic valid[lines][way];  //valid
logic [1:0] pred[lines][way];  //prediction bit
logic [19:0] tag_data[lines][way]

logic sel[way];
logic hit;
integer way_sel;

/* compare the tag */
generate
genvar i;
for(i=0; i < way; i++) begin : COMPARE
	compare #(.width(20)) COMPAREi
	(
		.a(tag_data[index][i]),
		.b(tag),
		.out(compare_out[i])
	);
end
endgenerate

/* combine the compare signal with valid bit */
always_comb begin
	for(integer i = 0; i<way; i++) begin
		sel[i] = valid[index][i] & compare_oout[i];
		if(sel[i] != 0) begin
		hit = 1'b1;
		way_sel = i;
		end
	if(sel[0] == 0 && sel[1] ==0 && sel[2] == 0 && sel[3] == 0)
	hit = 1'b0;
	end
end

/* not sure whether it is right */
/* LRU */
logic temp[3];
integer way_out;
always_comb begin
	temp = LRU[index];
	if(hit) begin
		case(way_sel)
		0: begin
		LRU[index][0] = 1'b0;
		LRU[index][1] = 1'b0;
		




endmodule: btb		
