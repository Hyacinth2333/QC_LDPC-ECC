module part_add1(
			input [14*27-1:0] index_to_q,
			output[14*27-1:0] index_to_q_add1
		);

generate
genvar i;
	for(i=0;i<27;i=i+1)
	begin:part_add
		assign index_to_q_add1[14*i+:8]=index_to_q[14*i+:8]+1'b1;
		assign index_to_q_add1[14*i+8+:6]=index_to_q[14*i+8+:6];
	end
endgenerate
endmodule
		
