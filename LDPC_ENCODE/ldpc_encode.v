module ldpc_encode(
			input clk,
			input rst_n,
			input[7:0] d_in,
			input en_start,
			input en_din,
			input read_parity,
			output done_encode,
			output en_out,
			output[7:0] d_out
		   );

wire parity_out_done,en_counterROM,en_counterOUT,en_G,load_g,rstc,en_L;
wire[1023:0] L;

control_encode e1(clk,rst_n,en_start,en_din,read_parity,parity_out_done,en_counterROM,en_counterOUT,en_G,load_g,en_L,done_encode,rstc,en_out);
parallel_encode e2(d_in,clk,rst_n,rstc,en_counterROM,en_G,load_g,en_L,en_out,L);
parity_out e3(clk,rst_n,en_counterOUT,rstc,L,parity_out_done,d_out);

endmodule
