module TOP(
	input ck,reset,
	output scl,
	inout sda
);

wire ck1,ck2,ctrl_d,sda_w,ctrl_l,ctrl_h;
wire [6:0]cmd_address;
wire [7:0]cmd_data;

assign sda = (ctrl_d)? sda_w : 1'bz;
assign scl = ctrl_h | (~ctrl_l & ck1);

divider ic1(
	.ck(ck),
	.reset(reset),
	.clk2(ck2),
	.clk1(ck1)
);

ctrl ic2(
	.sda(sda),
	.clk2(ck2),
	.reset(reset),
	.cmd_data(cmd_data),
	.cmd_address(cmd_address),
	.sda_w(sda_w),
	.ctrl_d(ctrl_d),
	.ctrl_l(ctrl_l),
	.ctrl_h(ctrl_h)
);

cmd_rom ic3(
	//.ck(ck),
	.address(cmd_address),
	.data_out(cmd_data)
);



endmodule
