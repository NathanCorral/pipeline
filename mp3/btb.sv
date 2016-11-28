import lc3b_types::*;

module btb #(parameter way = 4, lines = 1024)
(
 input clk,
 input lc3b_word pc_id,
 input lc3b_word pc_wb,
 input lc3b_word pc_mux_out,
 input lc3b_opcode opcode_wb,
 input pc_sel_out_sel,
 output lc3b_word branch_address
);
logic offset;
logic [10:0]index;
logic [19:0]tag;
logic offset_wb;
logic [10:0]imdex_wb;
logic [19:0]tag_wb;

/* pc */
assign offset_id = pc_id[0];
assign index_id = pc_id[10:1];
assign tag_id = pc_id[31:11];
assign offset_wb = pc_wb[0];
assign index_wb = pc_wb[10:1];
assign tag_wb = pc_wb[31:11];

/* array for address */
logic [15:0] br_address[lines][way]; //branch address
logic  LRU[lines][3];  //LRU
logic valid[lines][way];  //valid
logic [20:0] tag_data[lines][way];

logic sel_id[way];
logic sel_wb[way];
logic hit_id;
logic hit_wb;
integer way_sel_id;
integer way_sel_wb;
logic compare_out_id[way];
logic compare_out_wb[way];

/* compare the tag */
generate
genvar i;
for(i=0; i < way; i++) begin : COMPARE
	compare #(.width(21)) COMPAREid
	(
		.a(tag_data[index_id][i]),
		.b(tag_id),
		.out(compare_out_id[i])
	);
	compare #(.width(21)) COMPAREwb
	(
		.a(tag_data[index_wb][i]),
		.b(tag_wb),
		.out(compare_out_wb[i])
	);
end
endgenerate



/* combine the compare signal with valid bit */
always_comb begin
	for(integer i = 0; i<way; i++) begin
		sel_id[i] = valid[index_id][i] & compare_out_id[i];
		if(sel_id[i] != 0) begin
		hit_id = 1'b1;
		way_sel_id = i;
		end
	if(sel_id[0] == 0 && sel_id[1] ==0 && sel_id[2] == 0 && sel_id[3] == 0)
	hit_id = 1'b0;
	end
end

always_comb
begin
	if(hit_id)
	branch_address = br_address[index_id][way_sel_id];
	else
	branch_address = branch_address + 2;
end


/* LRU and output*/
always_ff @(posedge clk)
begin
	if(opcode_wb == 4'b0000 && pc_sel_out_sel == 1) begin
	if(hit_wb) 
	/* if hit, update the LRU*/
	/* the address depends on whether it is taken  */
	begin
		case(way_sel_wb)
		0: begin
		LRU[index_wb][2] = 0;
		LRU[index_wb][1] = 0;
		end
		1: begin
		LRU[index_wb][2] = 0;
		LRU[index_wb][1] = 1;
		end
		2: begin
		LRU[index_wb][2] = 1;
		LRU[index_wb][0] = 0;
		end
		3: begin
		LRU[index_wb][2] = 1;
		LRU[index_wb][0] = 1;
		end
		default: LRU[index_wb] = 3'b000;
		endcase
                                                                                                                                                                                                                                                                      

	end
	else begin 
	/* if not hit, the way is the output of lru */
	/* again update lru */
	/* update the tag, valid, data */
	/* the output address is the lru address */
	if(LRU[index_wb][2] == 1 && LRU[index_wb][1] == 1) begin
	LRU[index_wb][2] = 0;
	LRU[index_wb][1] = 0;
	br_address = pc_mux_out;
	valid[index_wb][0] = 1;
	tag_data[index_wb][0] = tag_wb;


	end
	
	if(LRU[index_wb][2] == 1 && LRU[index_wb][1] == 0) begin
	LRU[index_wb][2] = 0;
	LRU[index_wb][1] = 1;
	br_address = pc_mux_out;
	valid[index_wb][1] = 1;
	tag_data[index_wb][1] = tag_wb;


	end
	
	if(LRU[index_wb][2] == 0 && LRU[index_wb][0] == 1) begin
	LRU[index_wb][2] = 1;
	LRU[index_wb][0] = 0;
	br_address = pc_mux_out;
	valid[index_wb][2] = 1;
	tag_data[index_wb][2] = tag_wb;



	end
	
	if(LRU[index_wb][2] == 0 && LRU[index_wb][1] == 0) begin
	LRU[index_wb][2] = 1;
	LRU[index_wb][0] = 1;
	br_address = pc_mux_out;
	valid[index_wb][3] = 1;
	tag_data[index_wb][3] = tag_wb;



	end
	
	end
end
end




endmodule: btb
