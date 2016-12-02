import lc3b_types::*;

module btb #(parameter way = 4, lines = 32)
(
 input clk,
 input lc3b_word pc_if,
 input lc3b_word pc_wb,
 input lc3b_word alu_out_wb,
 input lc3b_word mem_wb,
 input lc3b_opcode opcode_wb,
 input is_valid_inst_wb,
 output lc3b_word branch_address
);
logic [4:0]index_id;
logic [9:0]tag_id;
logic [4:0]index_wb;
logic [9:0]tag_wb;

/* pc */
assign index_id = pc_if[5:1];
assign tag_id = pc_if[15:6];
assign index_wb = pc_wb[5:1];
assign tag_wb = pc_wb[15:6];

/* array for address */
logic [15:0] br_address[lines][way]; //branch address
logic  LRU[lines][3];  //LRU
logic valid[lines][way];  //valid
logic [9:0] tag_data[lines][way];

logic sel_id[way];
logic sel_wb[way];
logic hit_id;
logic hit_wb;
integer way_sel_id;
integer way_sel_wb;
logic compare_out_id[way];
logic compare_out_wb[way];

initial
begin
    for (int i = 0; i < lines; i++)
    begin
        LRU[i][0] = 1'b0;
        LRU[i][1] = 1'b0;
        LRU[i][2] = 1'b0;
    end

    for (int i = 0; i < lines; i++)
    begin
        for (int j = 0; j < way; j++)
        begin
            br_address[i][j] = 16'h0;
            valid[i][j] = 1'b0;
        end
    end
end

/* compare the tag */
generate
genvar i;
for(i=0; i < way; i++) begin : COMPARE
	compare #(.width(10)) COMPAREid
	(
		.a(tag_data[index_id][i]),
		.b(tag_id),
		.out(compare_out_id[i])
	);
	compare #(.width(10)) COMPAREwb
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
        // branch predictions seem to be a little bit off unless we include
        // a break statement after way_sel_id is set. Unfortunately break
        // doesn't seem to be synthesizable
        // taking out the else clause also works, but is also not synthesizable
		end
	if(sel_id[1]) way_sel_id = 1;
	else if(sel_id[2]) way_sel_id = 2;
	else if(sel_id[3]) way_sel_id = 3;
	else way_sel_id = 0;
	if(sel_id[0] == 0 && sel_id[1] ==0 && sel_id[2] == 0 && sel_id[3] == 0)
	hit_id = 1'b0;
	else 
	hit_id = 1'b1;
end

always_comb begin
	for(integer i = 0; i<way; i++) begin
		sel_wb[i] = valid[index_wb][i] & compare_out_wb[i];
		end
	if(sel_wb[1]) way_sel_wb = 1;
	else if(sel_wb[2]) way_sel_wb = 2;
	else if(sel_wb[3]) way_sel_wb = 3;
	else way_sel_wb = 0;
	if(sel_wb[0] == 0 && sel_wb[1] ==0 && sel_wb[2] == 0 && sel_wb[3] == 0)
	hit_wb = 1'b0;
	else 
	hit_wb = 1'b1;
end

// if we want this clocked, it needs to be clocked based on hit_id or something,
// but not the actual clock, actual clock causes it to lag 1 cycle and gives
// horrible prediction results
// if we don't want it clocked, we can set branch address to pc_if on a miss
// basically, it has to be always_comb with branch_address = pc_if, or
// always_ff @(posedge hit_id) with branch_address = branch_address

//always_ff @(posedge clk)
always_comb
//always_ff @(posedge hit_id)
begin
	if(hit_id == 1'b1)
	branch_address = br_address[index_id][way_sel_id];
	else
    //used to be branch_address = branch_address
	branch_address = pc_if;
    //branch_address = branch_address;
end


/* LRU and output*/
always_ff @(posedge clk)
begin
	if(((opcode_wb == 4'b0000) || (opcode_wb == 4'b1100) || (opcode_wb == 4'b0100) || (opcode_wb == 4'b1111)) && is_valid_inst_wb == 1) begin
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
    if(opcode_wb == op_trap)
	    br_address[index_wb][0] = mem_wb;
    else
	    br_address[index_wb][0] = alu_out_wb;
	valid[index_wb][0] = 1;
	tag_data[index_wb][0] = tag_wb;


	end
	
	if(LRU[index_wb][2] == 1 && LRU[index_wb][1] == 0) begin
	LRU[index_wb][2] = 0;
	LRU[index_wb][1] = 1;
    if(opcode_wb == op_trap)
	br_address[index_wb][1] = mem_wb;
    else
	br_address[index_wb][1] = alu_out_wb;
	valid[index_wb][1] = 1;
	tag_data[index_wb][1] = tag_wb;


	end
	
	if(LRU[index_wb][2] == 0 && LRU[index_wb][0] == 1) begin
	LRU[index_wb][2] = 1;
	LRU[index_wb][0] = 0;
    if(opcode_wb == op_trap)
	br_address[index_wb][2] = mem_wb;
    else
	br_address[index_wb][2] = alu_out_wb;
	valid[index_wb][2] = 1;
	tag_data[index_wb][2] = tag_wb;



	end
	
	if(LRU[index_wb][2] == 0 && LRU[index_wb][0] == 0) begin
	LRU[index_wb][2] = 1;
	LRU[index_wb][0] = 1;
    if(opcode_wb == op_trap)
	br_address[index_wb][3] = mem_wb;
    else
	br_address[index_wb][3] = alu_out_wb;
	valid[index_wb][3] = 1;
	tag_data[index_wb][3] = tag_wb;



	end
	
	end
end
end




endmodule: btb
