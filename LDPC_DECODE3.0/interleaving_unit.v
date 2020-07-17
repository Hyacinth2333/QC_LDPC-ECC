module interleaving_unit(
				input clk,
				input rst_n,
				input [8*(32+3)-1:0] H_to_interleaving,
				input en_load,
				input f_one_iteration,
				output load_to_interleaving,
				output reg[14*(32+3)-1:0] H_to_sort
			);
reg[1:0] count_num;
reg[1:0] count_index;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_num<=0;
	else if(f_one_iteration)
		count_num<=0;
	else if(en_load)
		count_num<=count_num+1'b1;	

assign load_to_interleaving=(count_num==2'b11)?1:0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_index<=0;
	else if(f_one_iteration)
		count_index<=0;
	else if(load_to_interleaving)
		count_index<=count_index+1'b1;



integer i;
always@(*)
	for(i=0;i<35;i=i+1)
	if(i<32)
		begin
			if(H_to_interleaving[i*8+:8]==0)
				begin
				H_to_sort[i*14+:8]=0;
				H_to_sort[i*14+8+:6]=0;
				end
			else
				begin
				H_to_sort[i*14+:8]=H_to_interleaving[i*8+:8]+64*count_num;
				H_to_sort[i*14+8+:6]=i;
				end
		end
	else
		begin
		H_to_sort[i*14+:8]=H_to_interleaving[i*8+:8]+64*count_num-1'b1;
		H_to_sort[i*14+8+:6]=count_index+32;
		end



endmodule
				


			
				
