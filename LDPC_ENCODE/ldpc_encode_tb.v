`timescale 1ns/1ns
module ldpc_encode_tb;
reg clk;
reg rst_n;
reg [7:0] d_in;
reg en_start;
reg en_din;
reg read_parity;
wire done_encode;
wire en_out;
wire [7:0] d_out;

reg[7:0] mem[1023:0];
reg[9:0] addr_mem;
reg[7:0] ground_truth [127:0]; //the ground truth of ldpc encode

integer i;
integer error;

ldpc_encode d0(clk,rst_n,d_in,en_start,en_din,read_parity,done_encode,en_out,d_out);

initial 
begin
	$readmemb("D:/LDPC_ENCODE/encodedin.txt",mem);
	$readmemb("D:/LDPC_ENCODE/G2ROM0.txt",d0.e2.k0.ROM);
	$readmemb("D:/LDPC_ENCODE/G2ROM1.txt",d0.e2.k1.ROM);
	$readmemb("D:/LDPC_ENCODE/G2ROM2.txt",d0.e2.k2.ROM);
	$readmemb("D:/LDPC_ENCODE/G2ROM3.txt",d0.e2.k3.ROM);
	$readmemb("D:/LDPC_ENCODE/encodedout.txt",ground_truth);
end

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		addr_mem<=0;
	else if(en_din)
		addr_mem<=addr_mem+1'b1;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		d_in<=0;
	else if(en_din)
		d_in<=mem[addr_mem];

initial 
begin
	clk=0;
forever #10 clk=~clk;
end

initial 
begin
        rst_n=1;
#5      rst_n=0;
#10     rst_n=1;
end

initial
begin
	en_start=0;
#30	en_start=1;
#50     en_start=0;
end

initial 
begin
	en_din=0;
#50     en_din=1;
#20480  en_din=0;
end

initial 
begin
	read_parity=0;
#20600  read_parity=1;
#20     read_parity=0;
end

integer out_file;//定义文件句柄
	initial
	begin 
	   out_file=$fopen("data_out.txt","w");	
	end
	
always@(posedge clk)
	if(en_out) $fwrite(out_file,"%b\n",d_out[7:0]);




initial

begin	
	wait(en_out==1)
	begin
	for(i=0;i<128;i=i+1)
		begin
			error=0;
			@(posedge clk)
			begin
			if (d_out!= ground_truth[i]) error=error+1;
			end
		end
	end	
end	





	


endmodule
