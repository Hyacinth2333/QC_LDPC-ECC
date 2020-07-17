`include "para.v"
module CNU_unit(
			input clk,
			input rst_n,
			input load_to_CNU,
			input[64*(`iniBW+`exBW)*27-1:0] LLRq_in,
			input[64*(`iniBW+`exBW)*27-1:0] LLRr_in,
			output[64*(`iniBW+`exBW)*27-1:0] LLRq_out,
			output[64*(`iniBW+`exBW)*27-1:0] LLRr_out,
			output reg storage
		);
reg load_to_mem,load_temp,en_minimun,refresh_min,en_saturation,en_r_compute,en_q_compute;
reg[4:0] count_minimun;
wire en_refresh_min;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		load_to_mem<=0;
	else 
		load_to_mem<=load_to_CNU;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		load_temp<=0;
	else if(load_to_mem)
		load_temp<=1;
	else
		load_temp<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_minimun<=0;
	else if(load_temp)
		en_minimun<=1;
	else if(count_minimun==5'b11010)
		en_minimun<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_minimun<=0;
	else if(en_minimun)
		count_minimun<=count_minimun+1'b1;
	else if(storage)
		count_minimun<=0;

assign en_refresh_min=(count_minimun==5'b11010)&&en_minimun;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		refresh_min<=0;
	else if(en_refresh_min)
		refresh_min<=1;
	else 
		refresh_min<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_saturation<=0;
	else if(refresh_min)
		en_saturation<=1;
	else 
		en_saturation<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_r_compute<=0;
	else if(en_saturation)
		en_r_compute<=1;
	else 
		en_r_compute<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_q_compute<=0;
	else if(en_r_compute)
		en_q_compute<=1;
	else
		en_q_compute<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		storage<=0;
	else if(en_q_compute)
		storage<=1;
	else
		storage<=0;



generate
genvar i;
	for(i=0;i<64;i=i+1)
	begin:instant_cnu
		CNU_nms c0(clk,rst_n,load_to_mem,LLRq_in[i*(`iniBW+`exBW)*27+:(`iniBW+`exBW)*27],LLRr_in[i*(`iniBW+`exBW)*27+:(`iniBW+`exBW)*27],
			   load_temp,en_minimun,count_minimun,refresh_min,en_saturation,en_r_compute,en_q_compute,LLRq_out[i*(`iniBW+`exBW)*27+:(`iniBW+`exBW)*27],LLRr_out[i*(`iniBW+`exBW)*27+:(`iniBW+`exBW)*27]);
	end
endgenerate

endmodule
		
