module ldpc_decode( 
			input clk,
			input rst_n,
			input ready,
			input en_din,
			input [7:0] d_in,
			output [7:0] d_out,
			output en_out,
			output f_out,
			output flag_out
		  );

wire ack,finish_nms,load,load_vout,rst_flag,start_nms,shift_out;
wire[9215:0] buffer,v_out;
wire flag_reg;

control_decode z0(clk,rst_n,ready,en_din,ack,f_out,finish_nms,load,load_vout,en_out,rst_flag,start_nms,shift_out);
data_load      z1(clk,rst_n,d_in,load,buffer,ack);
nms_decode     z2(clk,rst_n,buffer,start_nms,flag_reg,v_out,finish_nms);
data_out       z3(clk,rst_n,flag_reg,shift_out,load_vout,en_out,rst_flag,finish_nms,v_out,f_out,d_out,flag_out);
endmodule
