module data_out(
			input clk,
			input rst_n,
			input flag_reg,
			input shift_out,
			input load_vout,
			input en_out,
			input rst_flag,
			input finish_nms,
			input[9215:0] v_out,
			output f_out,
			output[7:0] d_out,
			output reg flag_out
		);
reg[9215:0] vout;
reg[10:0] count_out;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_out<=11'b0;
	else if(f_out)
		count_out<=0;
	else if(en_out)
		count_out<=count_out+1'b1;

assign f_out=(count_out==11'b10_010_000_000)?1:0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		vout<=0;
	else if(load_vout)
		vout<=v_out;
	else if(shift_out)
		vout<={vout[7:0],vout[9215:8]};


assign d_out=vout[7:0];

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		flag_out<=0;
	else if(!rst_flag)
		flag_out<=0;
	else if(finish_nms)
		flag_out<=flag_reg;



endmodule
		
			
