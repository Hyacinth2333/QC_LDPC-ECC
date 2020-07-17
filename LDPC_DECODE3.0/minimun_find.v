`include "para.v"
module minimun_find(
			input[(`iniBW+`exBW)*26-1:0] r_temp,
			output reg[(`iniBW+`exBW)-1:0] minimun_out
		    );
integer i;
always@(*)
begin
		minimun_out=8'b1111_1111;
		for(i=0;i<26;i=i+1)
			if(r_temp[i*(`iniBW+`exBW)+:(`iniBW+`exBW)]<minimun_out)
				minimun_out=r_temp[i*(`iniBW+`exBW)+:(`iniBW+`exBW)];
end
endmodule
