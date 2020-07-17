module parallel_cell(
			input[7:0] d_in,
			input	L_ref,
			input[7:0] buffer,
			output d_out
		     );

wire[7:0] b;
wire[3:0] c;
wire[1:0] d;
wire e;

generate
genvar i;
	for(i=0;i<8;i=i+1)
		begin:and_operation
			assign b[i]=d_in[i]&buffer[7-i];
		end
endgenerate

assign c[0]=b[0]^b[1];
assign c[1]=b[2]^b[3];
assign c[2]=b[4]^b[5];
assign c[3]=b[6]^b[7];
assign d[0]=c[0]^c[1];
assign d[1]=c[2]^c[3];
assign e=d[0]^d[1];
assign d_out=e^L_ref;

endmodule

			
