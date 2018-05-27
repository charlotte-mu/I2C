`timescale 1ns/10ps

module testbench;

reg ck_w,reseat_w;
wire sda,scl;

/*divider top(
	.reset(reseat_w),
	.clk1(clk1),
	.clk2(clk2),
	.ck(ck_w)
);*/

TOP top(
	.ck(ck_w),
	.reset(reseat_w),
	.sda(sda),
	.scl(scl)
);

always 
	#10 ck_w = ~ck_w;

initial 
begin
				ck_w = 1'd0;
				reseat_w = 1'b0;
	#100 		reseat_w = 1'b1;
	#5000000 	$finish;
end

endmodule
