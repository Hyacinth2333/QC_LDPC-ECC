`include "para.v"
module CNU_nms(
		input clk,
		input rst_n,
		input load_to_mem,		//enable signal of loading LLRq_in to qin_mem and LLRr_in to rin_mem
		input[(`iniBW+`exBW)*27-1:0] LLRq_in,//Probability information of variable nodes,iniBW->6,exBW->2,row weight->27
		input[(`iniBW+`exBW)*27-1:0] LLRr_in,//Probability information of Calibration nodes
		input load_temp,//enable signal of performing LLRq_in-LLRr_in
		input en_minimun,//enable signal of selecting of minimun value and second minimun value
		input[4:0] count_minimun,//counting from 0 to 26
		input refresh_min,//enable signal for refreshing (LLRq_in-LLRr_in) to the minimun value excepting itself
		input en_saturation,//enable signal of doing saturation limit
		input en_r_compute,//enable signal of computing LLRr_out
		input en_q_compute,//enable signal of computing LLRq_oyt
	        output[(`iniBW+`exBW)*27-1:0] LLRq_out,
		output reg[(`iniBW+`exBW)*27-1:0] LLRr_out
		);

reg[(`iniBW+`exBW)*27-1:0] qin_mem;
reg[(`iniBW+`exBW)*27-1:0] rin_mem;
wire[27*(`iniBW+`exBW)-1:0] temp_cache;//storage the value of LLRq_in-LLRr_in in the form of Orginal code,excepting the sign bit
reg[27*(`iniBW+`exBW)-1:0] temp_cache_min;//storage the value picking from minimun_value,sec_value
reg[27*(`iniBW+`exBW-1)-1:0] temp_cache_satur;//storage the value after doing saturation limit
wire[26:0] sign_cache;//storage the sign bit of (LLRq_in-LLRr_in)
wire[26:0] sign;//storage the sign bit of LLRr_out
reg[`iniBW+`exBW-1:0]  minimun_value,sec_value;

reg[27*(`iniBW+`exBW+1)-1:0] Value;//for  multiplying 0.75
wire[27*(`iniBW+`exBW+1)-1:0] Value_add1;
wire[27*(`iniBW+`exBW+1)-1:0] Value_add2;
reg[27*(`iniBW+`exBW+1)-1:0] Value1;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
		qin_mem<=0;
		rin_mem<=0;
		end
	else if(load_to_mem)
		begin
		qin_mem<=LLRq_in;
		rin_mem<=LLRr_in;
		end

//LLRq_in-LLRr_in
generate
genvar j;
	for(j=0;j<27;j=j+1)
		begin:temp_compute
			benchmarkReduce u0(clk,rst_n,load_temp,qin_mem[j*(`iniBW+`exBW)+:(`iniBW+`exBW)],rin_mem[j*(`iniBW+`exBW)+:(`iniBW+`exBW)],sign_cache[j],temp_cache[j*(`iniBW+`exBW)+:(`iniBW+`exBW)]);
		end
endgenerate


//selecting minimun value and second minimun value
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			sec_value<=0;
			minimun_value<=0;
		end
	else if(en_saturation)
		begin
			sec_value<=0;
			minimun_value<=0;
		end
	else if(en_minimun)
		begin
			if(count_minimun==0)
				begin
					sec_value<=temp_cache[`iniBW+`exBW-1:0];
					minimun_value<=temp_cache[`iniBW+`exBW-1:0];
				end
			else if (temp_cache[count_minimun*(`iniBW+`exBW)+:(`iniBW+`exBW)]<sec_value)
				begin
					if(temp_cache[count_minimun*(`iniBW+`exBW)+:(`iniBW+`exBW)]<minimun_value)
						begin
							sec_value<=minimun_value;
							minimun_value<=temp_cache[count_minimun*(`iniBW+`exBW)+:(`iniBW+`exBW)];
						end
					else
						
						sec_value<=temp_cache[count_minimun*(`iniBW+`exBW)+:(`iniBW+`exBW)];
				end
		end

//picking the minimun value excepting itself from minimun value and second minimun value
generate 
genvar k;
	for(k=0;k<27;k=k+1)
	begin:min_cache
		always@(posedge clk or negedge rst_n)
			if(!rst_n)
				temp_cache_min[k*(`iniBW+`exBW)+:(`iniBW+`exBW)]<=0;
			else if(refresh_min)
				begin
				if(temp_cache[k*(`iniBW+`exBW)+:(`iniBW+`exBW)]==minimun_value)
					temp_cache_min[k*(`iniBW+`exBW)+:(`iniBW+`exBW)]<=sec_value;
				else
					temp_cache_min[k*(`iniBW+`exBW)+:(`iniBW+`exBW)]<=minimun_value;
				end
	end	
endgenerate

//doing saturation limit
generate 
genvar i;
	for(i=0;i<27;i=i+1)
	begin:saturation_limit
		always@(posedge clk or negedge rst_n)
			if(!rst_n)
				temp_cache_satur[i*(`iniBW+`exBW-1)+:(`iniBW+`exBW-1)]<=0;
			else if(en_saturation)
				begin
					if(temp_cache_min[i*(`iniBW+`exBW)+(`iniBW+`exBW)-1]==1)
						temp_cache_satur[i*(`iniBW+`exBW-1)+:(`iniBW+`exBW-1)]<=7'b111_1111;
					else
						temp_cache_satur[i*(`iniBW+`exBW-1)+:(`iniBW+`exBW-1)]<=temp_cache_min[i*(`iniBW+`exBW)+:(`iniBW+`exBW)-1];
				end
	end
endgenerate




	
//computing the sign bit for each LLRr_out
generate
genvar b;
	for(b=0;b<27;b=b+1)
		begin:Sign_bit_judgement
			assign sign[b]=(^sign_cache)^sign_cache[b];
		end
endgenerate


//multiplying 0.75,and computing LLRr_out
generate
genvar c;
	for(c=0;c<27;c=c+1)
		begin:LLRr_out_compute
			assign Value_add1[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]={2'b0,temp_cache_satur[c*(`iniBW+`exBW-1)+:`iniBW+`exBW-1]};
			assign Value_add2[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]={1'b0,temp_cache_satur[c*(`iniBW+`exBW-1)+:`iniBW+`exBW-1],1'b0};
			always@(posedge clk or negedge rst_n)
				if(!rst_n)
					Value[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]<=0;
				else if(en_r_compute)
					Value[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]<=Value_add1[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]+Value_add2[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)];
		
			always@(*)
				if(sign[c])
					Value1[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]=~Value[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]+1'b1;
				else
					Value1[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]=Value[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)];
			
			always@(*)
				if(Value1[c*(`iniBW+`exBW+1)+:(`iniBW+`exBW+1)]==0)
					LLRr_out[c*(`iniBW+`exBW)+:(`iniBW+`exBW)]=0;
				else 
					LLRr_out[c*(`iniBW+`exBW)+:(`iniBW+`exBW)]={sign[c],Value1[c*(`iniBW+`exBW+1)+2+:(`iniBW+`exBW-1)]};
		end
endgenerate
			

//computing LLRq_out,which equals to LLRq_in-LLRr_in+LLRr_out
generate
genvar p;
	for(p=0;p<27;p=p+1)
		begin:LLRq_out_compute
			q_compute u4(clk,rst_n,en_q_compute,qin_mem[p*(`iniBW+`exBW)+:(`iniBW+`exBW)],rin_mem[p*(`iniBW+`exBW)+:(`iniBW+`exBW)],LLRr_out[p*(`iniBW+`exBW)+:(`iniBW+`exBW)],LLRq_out[p*(`iniBW+`exBW)+:(`iniBW+`exBW)]);
		end
endgenerate

endmodule
			
									
					
		






					
			
			
			
