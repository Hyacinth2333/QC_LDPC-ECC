module parallel_encode(
			input[7:0] d_in,
			input clk,
			input rst_n,
			input rst_c,
			input en_counterROM,
			input en_G,
			input load_g,
			input en_L,
			input en_out,
			output reg[1023:0] L
		       );

reg[4:0] counterROM;
reg[4:0] addrROM;
wire addROM,a,load_G;

wire[255:0] L_in0,L_in1,L_in2,L_in3;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		counterROM<=5'b0;
	else if(!rst_c)
		counterROM<=5'b0;
	else if(a)
		counterROM<=5'b0;
	else if(en_counterROM)
		counterROM<=counterROM+1'b1;

assign addROM=(counterROM==5'b10_000)?1:0;
assign a=(counterROM==5'b11_111)?1:0;
assign load_G=load_g|a;

always@(posedge clk or negedge rst_n)   
	if(!rst_n)
		addrROM<=5'b0;
	else if(!rst_c)
		addrROM<=5'b0;
	else if(addROM)
		addrROM<=addrROM+1'b1;


encode_cell k0(d_in,clk,rst_n,rst_c,en_G,load_G,en_L,addrROM,L[255:0],L_in0);
encode_cell k1(d_in,clk,rst_n,rst_c,en_G,load_G,en_L,addrROM,L[511:256],L_in1);
encode_cell k2(d_in,clk,rst_n,rst_c,en_G,load_G,en_L,addrROM,L[767:512],L_in2);
encode_cell k3(d_in,clk,rst_n,rst_c,en_G,load_G,en_L,addrROM,L[1023:768],L_in3);

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		L<=0;
	else if(!rst_c)
		L<=0;
	else if(en_L)
		L<={L_in3,L_in2,L_in1,L_in0};
	else if(en_out)
		L<={L[7:0],L[1023:8]};

endmodule
					


			
		
		
		






			
