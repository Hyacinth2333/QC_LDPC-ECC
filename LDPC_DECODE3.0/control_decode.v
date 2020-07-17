module control_decode(
			input clk,
			input rst_n,
			input ready,
			input en_din,
			input ack,
			input f_out,
			input finish_nms,
			output reg load,
			output reg load_vout,
			output reg en_out,
			output reg rst_flag,
			output reg start_nms,
			output reg shift_out
			);

reg[3:0] nstate,cstate;
parameter S_idle=3'b000,S_data_load=3'b001,S_nms_start=3'b010,S_nms=3'b011,S_data_out=3'b100;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cstate<=S_idle;
	else
		cstate<=nstate;

always@(*)
begin
	load=0;en_out=0;load_vout=0;rst_flag=1;start_nms=0;shift_out=0;
	case(cstate)
	S_idle: begin
			if(ready)
				nstate=S_data_load;
			else
				nstate=S_idle;
		end

	S_data_load: begin
			if(en_din)
				begin
					load=1;
					nstate=S_data_load;
				end
			else if(ack)
				begin
					nstate=S_nms_start;
				end
			else
				nstate=S_data_load;
		     end
	
	S_nms_start: begin
			start_nms=1;
			nstate=S_nms;
		     end


	S_nms: begin	
				
		        if(finish_nms)
				begin
					load_vout=1;
					nstate=S_data_out;
				end

			else 
				nstate=S_nms;
		end

	S_data_out: begin
			if(f_out)
				begin
				nstate=S_idle;
				rst_flag=0;
				end
			else
				begin
				en_out=1;
				shift_out=1;
				nstate=S_data_out;
				end
		    end

	default: nstate=S_idle;
	endcase
end
endmodule
		
