`include "para.v"
module benchmarkReduce( input clk,
			input rst_n,
			input load_temp,
			input signed[`iniBW+`exBW-1:0] q_in,
		        input signed[`iniBW+`exBW-1:0] r_in,
			output reg sign_out,
			output reg[`iniBW+`exBW-1:0] q_out
		       );

wire[`iniBW+`exBW:0] temp_value;
wire sign_in;
reg[`iniBW+`exBW-1:0] q_out_in;
assign temp_value=q_in-r_in;
assign sign_in=temp_value[`iniBW+`exBW];

//tranforming from complement code to original code
always@(*)
	if(sign_in)
		q_out_in=(~temp_value[`iniBW+`exBW-1:0])+1'b1;
	else
		q_out_in=temp_value[`iniBW+`exBW-1:0];

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
		q_out<=0;
		end
	else if(load_temp)
		begin
		q_out<=q_out_in;
		end

always@(posedge clk or negedge rst_n)
	if(!rst_n)
	sign_out<=0;
	else if(load_temp)
	sign_out<=sign_in;
endmodule

		
	
			
