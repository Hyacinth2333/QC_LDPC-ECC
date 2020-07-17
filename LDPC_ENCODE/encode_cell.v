module encode_cell(
			input[7:0] d_in,
			input clk,
		        input rst_n,
			input rst_c,
			input en_G,
			input load_G,
			input en_L,
			input[4:0] addrROM,
			input reg[255:0] L_cell,
			output[255:0] L_in
		       );

reg[255:0] ROM[31:0];
reg[255:0] buffer_G;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		buffer_G<=256'b0;
	else if(!rst_c)
		buffer_G<=256'b0;
	else if(en_G)
		if(load_G)
			buffer_G<=ROM[addrROM];
		else
			buffer_G<={buffer_G[247:0],buffer_G[255:248]};




parallel_cell p0(d_in,L_cell[0],{buffer_G[0],buffer_G[255:249]},L_in[0]);
parallel_cell p1(d_in,L_cell[1],{buffer_G[1],buffer_G[0],buffer_G[255:250]},L_in[1]);
parallel_cell p2(d_in,L_cell[2],{buffer_G[2],buffer_G[1],buffer_G[0],buffer_G[255:251]},L_in[2]);
parallel_cell p3(d_in,L_cell[3],{buffer_G[3],buffer_G[2],buffer_G[1],buffer_G[0],buffer_G[255:252]},L_in[3]);
parallel_cell p4(d_in,L_cell[4],{buffer_G[4],buffer_G[3],buffer_G[2],buffer_G[1],buffer_G[0],buffer_G[255:253]},L_in[4]);
parallel_cell p5(d_in,L_cell[5],{buffer_G[5],buffer_G[4],buffer_G[3],buffer_G[2],buffer_G[1],buffer_G[0],buffer_G[255:254]},L_in[5]);
parallel_cell p6(d_in,L_cell[6],{buffer_G[6],buffer_G[5],buffer_G[4],buffer_G[3],buffer_G[2],buffer_G[1],buffer_G[0],buffer_G[255]},L_in[6]);
generate
genvar i;
	for(i=7;i<256;i=i+1)
		begin:parallel_compute
			parallel_cell p7(d_in,L_cell[i],buffer_G[i-:8],L_in[i]);
		end	
endgenerate	
endmodule
					


			
		
		
		






			