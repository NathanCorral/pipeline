module register #(parameter width = 16, parameter reset_val = 0)
(
    input clk,
	 input reset,
    input load,
    input [width-1:0] in,
    output logic [width-1:0] out
);

logic [width-1:0] data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */  
 /* Replaced for reset.  I dont know why initialization doesnt work on the free Modelsim license */
 /*
initial
begin
    data = 1'b0;
end
*/

always_ff @(posedge clk)
begin
	if(reset)
		data <= reset_val;
		
   else if (load)
    begin
        data = in;
    end
end

always_comb
begin		
   out = data;
end


endmodule : register
