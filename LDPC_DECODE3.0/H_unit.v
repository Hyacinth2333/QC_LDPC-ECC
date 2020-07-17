module H_unit(
		input clk,
		input rst_n,
		input start_H_unit,
		input f_one_iteration,
		input load_to_interleaving,
		output reg[8*(32+3)-1:0] H_to_interleaving
		);


reg[8*(32+3)-1:0] H[3:0];
reg[1:0] count;



always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count<=0;
	else if(f_one_iteration)
		count<=0;
	else if(load_to_interleaving|start_H_unit)
		count<=count+1'b1;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		H_to_interleaving<=0;
	else if(load_to_interleaving|start_H_unit)
		H_to_interleaving<=H[count];

endmodule


		
