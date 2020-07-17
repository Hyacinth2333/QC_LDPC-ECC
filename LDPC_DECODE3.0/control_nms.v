module control_nms(
			input clk,
			input rst_n,
			input start_nms,
			input last_iteration,
			input f_en_load,
			input f_sort0,
			input f_one_iteration,
			input finish,
			input flag_out,	
			input storage,
			input finish_bubble_sort,
			output reg en_bubble_sort,
			output reg start_q_unit,
			output reg start_H_unit,
			output reg en_load,
			output reg load_to_CNU,
			output reg judge,
			output reg rst_r,
			output reg rst_q_unit,
			output reg finish_nms
		);


parameter S0=4'b0000,S1=4'b0001,S2=4'b0010,S3=4'b0011,S4=4'b0100,S5=4'b0101,S6=4'b0110,S7=4'b0111,S8=4'b1000,S9=4'b1001;
reg[3:0] cstate,nstate;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cstate<=S0;
	else 
		cstate<=nstate;

always@(*)
begin
	en_bubble_sort=0;start_q_unit=0;start_H_unit=0;en_load=0;
	load_to_CNU=0;judge=0;rst_r=1;rst_q_unit=1;finish_nms=0;
	case(cstate)
	S0: begin
		if(start_nms)
			begin
				start_q_unit=1;
				start_H_unit=1;
				nstate=S1;
			end
		else 
			nstate=S0;
	    end

	S1: begin
		if(f_en_load)
			begin
				nstate=S2;
			end
		else
			begin
				en_load=1;
				nstate=S1;
			end
	    end
	
	S2: begin
		if(f_sort0)
			begin
				en_bubble_sort=1;
				nstate=S3;
			end
		else
			nstate=S2;
	    end

	S3: begin
		
		if(finish_bubble_sort)
			begin
			nstate=S4;
			end
		else
			begin
			en_bubble_sort=1;
			nstate=S3;
			end
	    end

	S4: begin
			load_to_CNU=1;
			nstate=S5;
	    end

	S5: begin
			if(storage)
				nstate=S6;
			else 
				nstate=S5;
	     end
	
	S6: begin
		if(f_one_iteration)
			begin
				nstate=S7;
			end
		else
			begin
				en_bubble_sort=1;
				nstate=S3;
			end
	    end

	S7: begin
			judge=1;
			nstate=S8;
	    end

	S8: begin
		if(finish)
			nstate=S9;
		else
			begin
			judge=1;
			nstate=S8;
			end
      	     end

	S9: begin
		if(flag_out)
			begin
			nstate=S0;
			rst_r=0;
			rst_q_unit=0;
			finish_nms=1;
			end
		else if(last_iteration)
			begin
			nstate=S0;
			rst_r=0;
			rst_q_unit=0;
			finish_nms=1;
			end
		else 
			begin
			en_bubble_sort=1;
			nstate=S3;
			end
	    end

	default: nstate=S0;
	endcase
end

endmodule

		