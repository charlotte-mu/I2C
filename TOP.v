module TOP(
	input ck,reset,
	output scl,ck1,ck2,
	inout sda
);

wire scl_w,sda_w,ctrl_h,select;
wire [9:0]address;
wire [7:0]cmd_data,lcd_data,data;

assign sda = (sda_w)? 1'bz : 1'b0;
assign scl = (scl_w)? 1'bz : 1'b0;
assign scl_w =(ctrl_h | ck1);
assign data = (select)? lcd_data : cmd_data;

divider ic1(
	.ck(ck),
	.reset(reset),
	.clk2(ck2),
	.clk1(ck1)
);

ctrl ic2(
	.sda(sda),
	.clk2(ck2),
	.clk1(ck1),
	.reset(reset),
	.sda_w(sda_w),
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
