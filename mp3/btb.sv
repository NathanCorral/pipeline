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
logic [1:0] LRU;  //LRU
logic valid[lines][way];  //valid
logic [1:0] pred[lines][way];  //prediction bit
logic [19:0] tag_data[lines][way]



/* compare the tag */
generate
genvar i;
for(i=0; i < way; i++) begin : COMPARE
	compare #(.width(20)) COMPAREi
	(
		.a(tag_data[index][i],
		.b(tag),
		.out(compare_out[i])
	);
end
endgenerate

/* combine the compare signal with valid bit */
always_comb begin
	for(integer i = 0; i<way; i++) begin
		hit[i] = valid[index][i] & compare_oout[i];
	end
end






endmodule: but		
