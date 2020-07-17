`include "para.v"
module loopReduce(
			input clk,
			input rst_n,
			input load_temp,
			input signed[`iniBW+`exBW-1:0] q_in,
		        input signed[`iniBW+`exBW-1:0] r_in,
			output reg sign,
			output reg[`iniBW+`exBW-1:0] temp_r
		      );
wire[`iniBW+`exBW:0] temp;
reg[`iniBW+`exBW-1:0] temp_r_in;

assign temp=q_in-r_in;

assign sign_in=temp[`iniBW+`exBW];

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		sign<=0;
	else if(load_temp)
		sign<=sign_in;

always@(*)
	if(sign_in)
		temp_r_in=(~temp[`iniBW+`exBW-1:0])+1'b1;
	else
		temp_r_in=temp[`iniBW+`exBW-1:0];
	

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		temp_r<=0;
	else if(load_temp)
		temp_r<=temp_r_in;

endmodule


