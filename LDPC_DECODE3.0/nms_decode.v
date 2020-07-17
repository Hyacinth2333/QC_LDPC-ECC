`include "para.v"
module nms_decode(
			input clk,
			input rst_n,
			input[9215:0] buffer_in,
			input start_nms,
			output flag_reg,
			output[9215:0] vout,
			output finish_nms
		);

wire last_iteration,f_en_load,f_sort0,f_one_iteration,finish,start_q_unit,start_H_unit,en_load,load_to_CNU,judge,rst_r,rst_q_unit;
wire[8*(32+3)-1:0] H_to_interleaving;
wire load_to_interleaving;
wire[14*(32+3)-1:0] H_to_sort;
wire[16*14*(32+3)-1:0] index_to_q_unit;
wire[4:0] count_storage;
wire[14*27-1:0] index_to_q;
wire storage,en_bubble_sort,finish_bubble_sort;
wire[64*(`iniBW+`exBW)*27-1:0] LLRq_out,LLRq_in,LLRr_out,LLRr_in;

control_nms       k0(clk,rst_n,start_nms,last_iteration,f_en_load,f_sort0,f_one_iteration,finish,flag_reg,storage,finish_bubble_sort,en_bubble_sort,
	             start_q_unit,start_H_unit,en_load,load_to_CNU,judge,rst_r,rst_q_unit,finish_nms);

H_unit 	          k1(clk,rst_n,start_H_unit,f_one_iteration,load_to_interleaving,H_to_interleaving);
interleaving_unit k2(clk,rst_n,H_to_interleaving,en_load,f_one_iteration,load_to_interleaving,H_to_sort);
sort_unit         k3(clk,rst_n,en_load,count_storage,H_to_sort,f_en_load,index_to_q,f_sort0,index_to_q_unit);
q_unit            k4(clk,rst_n,rst_q_unit,start_q_unit,storage,buffer_in,LLRq_out,index_to_q,en_bubble_sort,finish_bubble_sort,LLRq_in,vout,f_one_iteration,last_iteration,count_storage);
r_unit            k5(clk,rst_n,rst_r,f_one_iteration,load_to_CNU,storage,LLRr_out,LLRr_in);
CNU_unit          k6(clk,rst_n,load_to_CNU,LLRq_in,LLRr_in,LLRq_out,LLRr_out,storage);
judge_unit        k7(clk,rst_n,index_to_q_unit,vout,judge,finish,flag_reg);

endmodule

