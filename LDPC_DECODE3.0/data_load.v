module data_load(
		 	input clk,
			input rst_n,
			input[7:0] d_in,
			input load,
			output reg[9215:0] buffer,
			output ack
		);

reg[10:0] count_load;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_load<=11'b0;
	else if(ack)
		count_load<=0;
	else if(load)
		count_load<=count_load+1'b1;

assign ack=(count_load==11'b10_010_000_000)?1:0;//1152count

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		buffer<=0;
	else if(load)
		buffer<={d_in,buffer[9215:8]};


endmodule
