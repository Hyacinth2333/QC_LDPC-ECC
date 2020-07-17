module control_encode(
			input clk,   //global signal
			input rst_n, //global signal
			input en_start, //from flash controller
			input en_din,   //from flash controller
			input read_parity, //from flash controller
			input parity_out_done, //from parity_out
			output reg en_counterROM, //to parallel_encode
			output reg en_counterOUT, //to parity_out
			output reg en_G,  //to parallel_encode
			output reg load_g, //to parallel_encode
			output reg en_L, //to parallel_encode
			output reg done_encode, //to flash controller
			output reg rst_c,
			output reg en_out  //to flash controller,parallel_encode
		      );


parameter S_idle=2'b00,S_encode=2'b01,S_parity_out=2'b10;
reg[1:0] cstate,nstate;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cstate<=S_idle;
	else 
		cstate<=nstate;

always@(*)
	begin
		en_counterROM=0;
		en_counterOUT=0;
		en_G=0;
		load_g=0;
		en_L=0;
		done_encode=0;
		en_out=0;
		rst_c=1;

	case(cstate)
		S_idle: begin
				if(en_start)
					begin
						nstate=S_encode;
						en_G=1;
						load_g=1;
					end
				else
					nstate=S_idle;
			end

		S_encode: begin
				if(en_din)
					begin
						en_counterROM=1;
						en_L=1;
						en_G=1;
						nstate=S_encode;
					end

				else if(read_parity)
					begin
						en_out=1;
						en_counterOUT=1;
						nstate=S_parity_out;
					end
				else
					begin
						done_encode=1;
						nstate=S_encode;
					end
			   end

		S_parity_out: begin
					if(!parity_out_done)
						begin
							en_counterOUT=1;
							en_out=1;
							nstate=S_parity_out;
						end
					else
						begin
							rst_c=0;
							nstate=S_idle;
						end
				end

		default: 	nstate=S_idle;
	endcase
	end

endmodule

							
			  
				






			
