module judge_unit(
			input clk,
			input rst_n,
			input[16*14*(32+3)-1:0] index_to_q_unit,
			input[9215:0] vout,
			input judge,
			output finish,
			output reg flag_out
		);
wire[255:0] flag_r;
wire flag;
reg[1:0] count_judge;
wire[14*27-1:0] index_judge0;
wire[14*27-1:0] index_judge1;
wire[14*27-1:0] index_judge2;
wire[14*27-1:0] index_judge3;

wire[64*14*27-1:0] ex_index_judge0;
wire[64*14*27-1:0] ex_index_judge1;
wire[64*14*27-1:0] ex_index_judge2;
wire[64*14*27-1:0] ex_index_judge3;

assign ex_index_judge0[14*27-1:0]=index_judge0;
assign ex_index_judge1[14*27-1:0]=index_judge0;
assign ex_index_judge2[14*27-1:0]=index_judge0;
assign ex_index_judge3[14*27-1:0]=index_judge0;


assign index_judge0=index_to_q_unit[count_judge*4*14*(32+3)+8*14+:27*14];
assign index_judge1=index_to_q_unit[count_judge*4*14*(32+3)+14*(32+3)+8*14+:27*14];
assign index_judge2=index_to_q_unit[count_judge*4*14*(32+3)+2*14*(32+3)+8*14+:27*14];
assign index_judge3=index_to_q_unit[count_judge*4*14*(32+3)+3*14*(32+3)+8*14+:27*14];

generate
genvar i;
	for(i=1;i<64;i=i+1)
	begin:judge_extend
		part_add1 x0(ex_index_judge0[(i-1)*14*27+:14*27],ex_index_judge0[i*14*27+:14*27]);
		part_add1 x1(ex_index_judge1[(i-1)*14*27+:14*27],ex_index_judge1[i*14*27+:14*27]);
		part_add1 x2(ex_index_judge2[(i-1)*14*27+:14*27],ex_index_judge2[i*14*27+:14*27]);
		part_add1 x3(ex_index_judge3[(i-1)*14*27+:14*27],ex_index_judge3[i*14*27+:14*27]);
	end
endgenerate




generate
genvar a;
	for(a=0;a<64;a=a+1)
	begin:flag_r_0
		add_judge_r y0(vout,ex_index_judge0[a*14*27+:14*27],flag_r[a]);
	end
endgenerate

generate
genvar b;
	for(b=0;b<64;b=b+1)
	begin:flag_r_1
		add_judge_r y1(vout,ex_index_judge1[b*14*27+:14*27],flag_r[64+b]);
	end
endgenerate

generate
genvar c;
	for(c=0;c<64;c=c+1)
	begin:flag_r_2
		add_judge_r y2(vout,ex_index_judge2[c*14*27+:14*27],flag_r[128+c]);
	end
endgenerate

generate
genvar d;
	for(d=0;d<64;d=d+1)
	begin:flag_r_3
		add_judge_r y3(vout,ex_index_judge3[d*14*27+:14*27],flag_r[192+d]);
	end
endgenerate


assign flag=|flag_r;
assign finish=(count_judge==2'b11)|flag;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		flag_out<=0;
	else if(finish)
		flag_out<=~flag;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_judge<=0;
	else if(finish)
		count_judge<=0;
	else if(judge)
		count_judge<=count_judge+1'b1;


endmodule


		
		


	

		