module sort_unit(
			input clk,
			input rst_n,
			input en_load,
			input[4:0] count_storage ,
			input[14*(32+3)-1:0] H_to_sort,
			output f_en_load,
			output reg[14*27-1:0] index_to_q ,
			output f_sort0,
			output[16*14*(32+3)-1:0] index_to_q_unit
		);

reg[14*(32+3)-1:0] sort_RAM[15:0];

reg[4:0] w_addr;
reg[3:0] r_addr;
reg a;
reg[16*14*(32+3)-1:0] index_to_q_unit_in;
wire[16*14*(32+3)-1:0] index_to_q_unit_in1;
reg[15:0] en_sort;
reg en_count_sort0;
reg[5:0] count_sort0;
wire f_count_sort0;

assign index_to_q_unit_in1=index_to_q_unit_in;


		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		w_addr<=0;
	else if(f_en_load)
		w_addr<=0;
	else if(en_load)
		w_addr<=w_addr+1'b1;

assign f_en_load=(w_addr==5'b10000)?1:0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		a<=0;
	else if(en_load)
		a<=1;
	else
		a<=0;

always@(posedge clk)
	if(en_load)
	sort_RAM[w_addr[3:0]]<=H_to_sort;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_addr<=0;
	else if(a)
		r_addr<=r_addr+1'b1;
	else 
		r_addr<=0;

always@(posedge clk)
	if(a)
		index_to_q_unit_in[r_addr[3:0]*14*(32+3)+:14*(32+3)]<=sort_RAM[r_addr[3:0]];

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_count_sort0<=0;
	else if(en_load)
		en_count_sort0<=1'b1;
	else if(f_count_sort0)
		en_count_sort0<=1'b0;

assign f_count_sort0=(count_sort0==6'b100010)?1:0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_sort0<=0;
	else if(en_count_sort0)
		count_sort0<=count_sort0+1'b1;
	else 
		count_sort0<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[0]<=0;
	else if(en_count_sort0)
		en_sort[0]<=1;
	else 
		en_sort[0]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[1]<=0;
	else if(en_sort[0])
		en_sort[1]<=1'b1;
	else 
		en_sort[1]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[2]<=0;
	else if(en_sort[1])
		en_sort[2]<=1'b1;
	else 
		en_sort[2]<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[3]<=0;
	else if(en_sort[2])
		en_sort[3]<=1'b1;
	else 
		en_sort[3]<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[4]<=0;
	else if(en_sort[3])
		en_sort[4]<=1'b1;
	else 
		en_sort[4]<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[5]<=0;
	else if(en_sort[4])
		en_sort[5]<=1'b1;
	else 
		en_sort[5]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[6]<=0;
	else if(en_sort[5])
		en_sort[6]<=1'b1;
	else 
		en_sort[6]<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[7]<=0;
	else if(en_sort[6])
		en_sort[7]<=1'b1;
	else 
		en_sort[7]<=0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[8]<=0;
	else if(en_sort[7])
		en_sort[8]<=1'b1;
	else 
		en_sort[8]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[9]<=0;
	else if(en_sort[8])
		en_sort[9]<=1'b1;
	else 
		en_sort[9]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[10]<=0;
	else if(en_sort[9])
		en_sort[10]<=1'b1;
	else 
		en_sort[10]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[11]<=0;
	else if(en_sort[10])
		en_sort[11]<=1'b1;
	else 
		en_sort[11]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[12]<=0;
	else if(en_sort[11])
		en_sort[12]<=1'b1;
	else 
		en_sort[12]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[13]<=0;
	else if(en_sort[12])
		en_sort[13]<=1'b1;
	else 
		en_sort[13]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[14]<=0;
	else if(en_sort[13])
		en_sort[14]<=1'b1;
	else 
		en_sort[14]<=0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_sort[15]<=0;
	else if(en_sort[14])
		en_sort[15]<=1'b1;
	else 
		en_sort[15]<=0;

generate
genvar i;
	for(i=0;i<16;i=i+1)
	begin:label_sort
		sort_index s0(clk,rst_n,en_sort[i],index_to_q_unit_in1[i*14*(32+3)+:14*(32+3)],index_to_q_unit[i*14*(32+3)+:14*(32+3)]);
	end
endgenerate

always@(*)
begin
	case(count_storage)
	5'b00000:  index_to_q=index_to_q_unit[35*14-1-:27*14];
	5'b00001:  index_to_q=index_to_q_unit[2*35*14-1-:27*14];
	5'b00010:  index_to_q=index_to_q_unit[3*35*14-1-:27*14];
	5'b00011:  index_to_q=index_to_q_unit[4*35*14-1-:27*14];
	5'b00100:  index_to_q=index_to_q_unit[5*35*14-1-:27*14];
	5'b00101:  index_to_q=index_to_q_unit[6*35*14-1-:27*14];
	5'b00110:  index_to_q=index_to_q_unit[7*35*14-1-:27*14];		
	5'b00111:  index_to_q=index_to_q_unit[8*35*14-1-:27*14];		
	5'b01000:  index_to_q=index_to_q_unit[9*35*14-1-:27*14];	
	5'b01001:  index_to_q=index_to_q_unit[10*35*14-1-:27*14];	
	5'b01010:  index_to_q=index_to_q_unit[11*35*14-1-:27*14];	
	5'b01011:  index_to_q=index_to_q_unit[12*35*14-1-:27*14];	
	5'b01100:  index_to_q=index_to_q_unit[13*35*14-1-:27*14];	
	5'b01101:  index_to_q=index_to_q_unit[14*35*14-1-:27*14];	
	5'b01110:  index_to_q=index_to_q_unit[15*35*14-1-:27*14];	
	5'b01111:  index_to_q=index_to_q_unit[16*35*14-1-:27*14];	
	default:		  index_to_q=0;
	endcase
end

assign f_sort0=(en_sort==16'b1111_1111_1111_1110)?1:0; 
endmodule
		




	
	




		
