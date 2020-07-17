`include "para.v"
module q_compute(
			input clk,
			input rst_n,
			input en_q_compute,
			input signed[`iniBW+`exBW-1:0] qtemp,
			input signed[`iniBW+`exBW-1:0] rtemp,
			input signed[`iniBW+`exBW-1:0] LLRr,
			output reg[`iniBW+`exBW-1:0] LLRq 
		);

wire[`iniBW+`exBW:0] qtemp1;
wire[`iniBW+`exBW+1:0] qtemp2;
wire[`iniBW+`exBW-1:0] LLRq_temp_in;
assign qtemp1={qtemp[`iniBW+`exBW-1],qtemp}-{rtemp[`iniBW+`exBW-1],rtemp};
assign qtemp2={qtemp1[`iniBW+`exBW],qtemp1}+{LLRr[`iniBW+`exBW-1],LLRr[`iniBW+`exBW-1],LLRr};
//assign qtemp1=qtemp-rtemp;
//assign qtemp2=qtemp1+LLRr;
assign LLRq_temp_in={qtemp2[`iniBW+`exBW+1],qtemp2[`iniBW+`exBW-2:0]};

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		LLRq<=0;
	else if(en_q_compute)
		LLRq<=LLRq_temp_in;
endmodule
