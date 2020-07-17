module parity_out(
			input clk,
			input rst_n,
			input en_counterOUT,
			input rst_c,
			input[1023:0] L,
			output parity_out_done,
			output[7:0] d_out
		);


reg[7:0] counterOUT;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		counterOUT<=0;
	else if(!rst_c)
		counterOUT<=0;
	else if(en_counterOUT)
		counterOUT<=counterOUT+1'b1;

assign d_out=L[7:0];

assign parity_out_done=(counterOUT==8'b10_000_000)?1:0;

endmodule



			