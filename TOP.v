module TOP(
	input ck,reset,
	output scl,ck1,ck2,
	inout sda
);

wire ctrl_d,sda_w,ctrl_l,ctrl_h,select;
wire [6:0]cmd_address;
wire [9:0]lcd_address,address;
wire [7:0]cmd_data,lcd_data,data;

assign sda = (ctrl_d)? sda_w : 1'bz;
assign scl = ctrl_h | (~ctrl_l & ck1);
assign data = (select)? lcd_data : cmd_data;

divider ic1(
	.ck(ck),
	.reset(reset),
	.clk2(ck2),
	.clk1(ck1)
);

ctrl ic2(
	.sda(sda),
	.scl(scl),
	.clk2(ck2),
	.clk1(ck1),
	.reset(reset),
	.sda_w(sda_w),
	.ctrl_d(ctrl_d),
	.ctrl_l(ctrl_l),
	.ctrl_h(ctrl_h),
	.data(data),
	.address(address),
	.select(select)
);

cmd_rom ic3(
	//.ck(ck),
	.address(address),
	.data_out(cmd_data)
);

lcd_rom ic4(
	//.ck(ck),
	.address(address),
	.data_out(lcd_data)
);



endmodule
