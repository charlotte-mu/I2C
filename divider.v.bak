module divider(
	input ck,reset,
	output reg clk1,clk2
);

parameter cnt1 = 250;
parameter cnt2 = 125;

reg [9:0]data1,data2;
reg r;

always@(posedge ck,negedge reset)
begin
	if(~reset)
	begin
		data1 <= 10'd0;
		clk1 <= 1'b0;
		//
		data2 <= 10'd0;
		clk2 <= 1'b0;
		r <= 1'd1;
	end
	else
	begin
		if(data1 == cnt1)
		begin
			data1 <= 10'd0;
			clk1 <= ~clk1;
		end
		else
		begin
			data1 <= data1 + 10'd1;
		end
		//
		if(data2 == cnt2)
		begin
			data2 <= 10'd0;
			if(r < 1'd1)
				r <= r + 1'd1;
			else
			begin
				clk2 <= ~clk2;
				r <= 1'd0;
			end
		end
		else
		begin
			data2 <= data2 + 10'd1;
		end
	end
end

endmodule
