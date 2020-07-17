`include "para.v"
module r_unit(
		input clk,
		input rst_n,
		input rst_r,
		input f_one_iteration,
		input load_to_CNU,
		input storage,
		input[64*(`iniBW+`exBW)*27-1:0] LLRr_out,
		output reg[64*(`iniBW+`exBW)*27-1:0] LLRr_in
	    );

reg[16*64*(`iniBW+`exBW)*27:0] r_MAM;
reg[3:0] addr;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		addr<=0;
	else if(f_one_iteration)
		addr<=0;
	else if(storage)
		addr<=addr+1'b1;




always@(posedge clk or negedge rst_n)
	if(!rst_n)
		LLRr_in<=0;
	else if(load_to_CNU)
		LLRr_in<=r_MAM[addr[3:0]*64*(`iniBW+`exBW)*27+:64*(`iniBW+`exBW)*27];
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_MAM<=0;
	else if(!rst_r)
		r_MAM<=0;
	else if(storage)
		r_MAM[addr[3:0]*64*(`iniBW+`exBW)*27+:64*(`iniBW+`exBW)*27]<=LLRr_out;

endmodule
