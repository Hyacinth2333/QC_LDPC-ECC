module sort_index(
			input clk,
			input rst_n,
			input en_sort,
			input[14*(32+3)-1:0] index_to_q_unit_in,
			output reg[14*(32+3)-1:0] index_to_q_unit
		);

reg[5:0] count_sort;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_sort<=0;
	else if(en_sort)
		count_sort<=count_sort+1'b1;
	else 
		count_sort<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		index_to_q_unit<=0;
	else if(en_sort)
		begin
			if(index_to_q_unit_in[count_sort*14+:14]==0)
				index_to_q_unit<=index_to_q_unit;
			else 
				index_to_q_unit<={index_to_q_unit_in[count_sort*14+:14],index_to_q_unit[14*(32+3)-1:14]};
		end
endmodule
