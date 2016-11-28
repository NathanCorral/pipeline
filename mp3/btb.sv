import lc3b_types::*;

module btb #(parameter way = 4, lines = 1024)
(
 input clk,
 input lc3b_word pc,
 input istaken,
 output lc3b_word branch_address
);
logic offset;
logic [10:0]index;
logic [19:0]tag;

/* pc */
assign offset = pc[0];
assign index = pc[10:1];
assign tag = pc[31:11];

/* array for address */
logic [15:0] br_address[lines][way]; //branch address
logic  LRU[lines][3];  //LRU
logic valid[lines][way];  //valid
logic [20:0] tag_data[lines][way];

logic sel[way];
logic hit;
integer way_sel;
logic compare_out[way];

/* compare the tag */
generate
genvar i;
for(i=0; i < way; i++) begin : COMPARE
	compare #(.width(21)) COMPAREi
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
		sel[i] = valid[index][i] & compare_out[i];
		if(sel[i] != 0) begin
		hit = 1'b1;
		way_sel = i;
		end
	if(sel[0] == 0 && sel[1] ==0 && sel[2] == 0 && sel[3] == 0)
	hit = 1'b0;
	end
end

/* LRU and output*/
always_ff @(posedge clk)
begin
	if(hit) 
	/* if hit, update the LRU*/
	/* the address depends on whether it is taken  */
	begin
		case(way_sel)
		0: begin
		LRU[index][2] = 0;
		LRU[index][1] = 0;
		end
		1: begin
		LRU[index][2] = 0;
		LRU[index][1] = 1;
		end
		2: begin
		LRU[index][2] = 1;
		LRU[index][0] = 0;
		end
		3: begin
		LRU[index][2] = 1;
		LRU[index][0] = 1;
		end
		default: LRU = 3'b000;
		endcase
		if(istaken)
		branch_address = br_address[index][way_sel];
		else
		branch_address = branch_address + 2;
	end
	else begin 
	/* if not hit, the way is the output of lru */
	/* again update lru */
	/* update the tag, valid, data */
	/* the output address is the lru address */
	if(LRU[index][2] == 1 && LRU[index][1] == 1) begin
	LRU[index][2] = 0;
	LRU[index][1] = 0;
	br_address = pc;
	valid[index][0] = 1;
	tag_data[index][0] = tag;
	if(istaken)
	branch_address = br_address[index][0];
	else
	branch_address = branch_address + 2;
	end
	
	if(LRU[index][2] == 1 && LRU[index][1] == 0) begin
	LRU[index][2] = 0;
	LRU[index][1] = 1;
	br_address = pc;
	valid[index][1] = 1;
	tag_data[index][1] = tag;
	if(istaken)
	branch_address = br_address[index][1];
	else
	branch_address = branch_address + 2;
	end
	
	if(LRU[index][2] == 0 && LRU[index][0] == 1) begin
	LRU[index][2] = 1;
	LRU[index][0] = 0;
	br_address = pc;
	valid[index][2] = 1;
	tag_data[index][2] = tag;
	if(istaken)
	branch_address = br_address[index][2];
	else
	branch_address = branch_address + 2;
	end
	
	if(LRU[index][2] == 0 && LRU[index][1] == 0) begin
	LRU[index][2] = 1;
	LRU[index][0] = 1;
	br_address = pc;
	valid[index][3] = 1;
	tag_data[index][3] = tag;
	if(istaken)
	branch_address = br_address[index][3];
	else
	branch_address = branch_address + 2;
	end
	
	end
end


endmodule: btb
