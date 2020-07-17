module add_judge_r(
			input[9215:0] vout,
			input[14*27-1:0] index_judge_in,
			output reg flag
		  );


integer j;
always@(*)
begin
		flag=0;
		for(j=0;j<27;j=j+1)
			flag=flag+vout[index_judge_in[j*14+:14]];
				
end

endmodule
		
