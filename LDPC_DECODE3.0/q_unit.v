`include "para.v"
module q_unit(
		input clk,
		input rst_n,
		input rst_q_unit,
		input start_q_unit,
		input storage,
		input[9215:0] v_in,
		input[64*(`iniBW+`exBW)*27-1:0] LLRq_out,
		input[14*27-1:0] index_to_q,		
		input en_bubble_sort,
		output finish_bubble_sort,
		output[64*(`iniBW+`exBW)*27-1:0] LLRq_in,
		output reg[9215:0] v_out,
		output  f_one_iteration,
		output last_iteration,
		output reg[4:0] count_storage
		);

reg[9216*(`iniBW+`exBW)-1:0] q_MAM;
reg[5:0] last_iteration_count;
wire[9215:0] v_out_in;
reg[9216*(`iniBW+`exBW)-1:0] q_MAM_in;
wire[64*14*27-1:0] index_to_q_ex;
reg[2:0] count_bubble_sort;
wire[64*14*27-1:0] index_to_q_ex_sort;
reg[64*24-1:0] bubble;
integer k;

assign index_to_q_ex[14*27-1:0]=index_to_q;
generate
genvar p;
	for(p=1;p<64;p=p+1)
	begin:link_addr1
		part_add1 x0(index_to_q_ex[(p-1)*14*27+:14*27],index_to_q_ex[p*14*27+:14*27]);
	end
endgenerate


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_bubble_sort<=0;
	else if(finish_bubble_sort)
		count_bubble_sort<=0;
	else if(en_bubble_sort)
		count_bubble_sort<=count_bubble_sort+1'b1;
	
assign finish_bubble_sort=(count_bubble_sort==3'b100)?1:0;

generate
genvar v;
	for(v=0;v<64;v=v+1)
	begin:bubble_sorting
		always@(posedge clk or negedge rst_n)
			if(!rst_n)
				begin
					bubble[v*24+:24]<=0;
				end
			else if(en_bubble_sort)
				begin
					if(count_bubble_sort==3'b0)
						begin
							bubble[v*24+:8]<=index_to_q_ex[v*14*27+14*24+:8];
							bubble[v*24+8+:8]<=index_to_q_ex[v*14*27+14*25+:8];
							bubble[v*24+16+:8]<=index_to_q_ex[v*14*27+14*26+:8];
						end
					if(count_bubble_sort==3'b001||count_bubble_sort==3'b011)
						begin
							if(bubble[v*24+:8]>bubble[v*24+8+:8])
								begin
									bubble[v*24+8+:8]<=bubble[v*24+:8];
									bubble[v*24+:8]<=bubble[v*24+8+:8];
								end
						end
					else if(count_bubble_sort==3'b010)
						begin
							if(bubble[v*24+8+:8]>bubble[v*24+16+:8])
								begin
									bubble[v*24+16+:8]<=bubble[v*24+8+:8];
									bubble[v*24+8+:8]<=bubble[v*24+16+:8];
								end
						end
				end
	end
endgenerate

generate 
genvar a;
	for(a=0;a<64;a=a+1)
	begin:link_index_to_q_ex_sort
		assign index_to_q_ex_sort[a*14*27+:14*27]={index_to_q_ex[a*14*27+14*26+8+:6],bubble[a*24+16+:8],index_to_q_ex[a*14*27+14*25+8+:6],bubble[a*24+8+:8],index_to_q_ex[a*14*27+14*24+8+:6],bubble[a*24+:8],index_to_q_ex[a*14*27+:14*24]};
	end
endgenerate
				


generate
genvar i;
	for(i=0;i<9216;i=i+1)
		begin:q_refresh1
			always@(posedge clk or negedge rst_n)
				if(!rst_n)
					q_MAM[i*(`iniBW+`exBW)+:(`iniBW+`exBW)]<=0;
				else if(start_q_unit)
					begin
						if(v_in[i]==1'b1)
							q_MAM[i*(`iniBW+`exBW)+:(`iniBW+`exBW)]<={5'b11111,3'b0};//
						else
							q_MAM[i*(`iniBW+`exBW)+:(`iniBW+`exBW)]<={4'b0,4'b1000};//
					end
				else if(storage)
					q_MAM[i*(`iniBW+`exBW)+:(`iniBW+`exBW)]<=q_MAM_in[i*(`iniBW+`exBW)+:`iniBW+`exBW];
		end
endgenerate

always@(*)
	begin
		q_MAM_in=q_MAM;
		for(k=0;k<27*64;k=k+1)
			 q_MAM_in[index_to_q_ex_sort[k*14+:14]*(`iniBW+`exBW)+:(`iniBW+`exBW)]=LLRq_out[k*(`iniBW+`exBW)+:(`iniBW+`exBW)];
	end





generate 
genvar j;
	for(j=0;j<27*64;j=j+1)
		begin:q_in_prepare
			assign LLRq_in[j*(`iniBW+`exBW)+:(`iniBW+`exBW)]=q_MAM[index_to_q_ex_sort[j*14+:14]*(`iniBW+`exBW)+:(`iniBW+`exBW)];
		end
endgenerate

generate
genvar m;
	for(m=0;m<9216;m=m+1)
		begin:v_out_judge
			assign v_out_in[m]=q_MAM[m*(`iniBW+`exBW)+(`iniBW+`exBW)-1];
		end
endgenerate




always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count_storage<=0;
	else if(f_one_iteration)
		count_storage<=0;
	else if(storage)
		count_storage<=count_storage+1'b1;
	

assign f_one_iteration=(count_storage==5'b10000)?1:0;



always@(posedge clk or negedge rst_n)
	if(!rst_n)
		v_out<=0;
	else if(f_one_iteration)
		v_out<=v_out_in;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		last_iteration_count<=0;
	else if(!rst_q_unit)
		last_iteration_count<=0;
	else if(f_one_iteration)
		last_iteration_count<=last_iteration_count+1'b1;

assign last_iteration=(last_iteration_count==5'b11110)?1:0;

endmodule
		
