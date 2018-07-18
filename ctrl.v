module ctrl(
	input reset,clk2,sda,clk1,
	input [7:0]data,
	output reg [9:0]address,
	output reg sda_w,ctrl_h,select
);

reg [9:0]address_next;
reg [2:0]fsm,fsm_next;
reg [3:0]add_con,add_con_next;
reg [7:0]address_7a,cmd_mod;
reg [1:0]mode,mode_next;
reg sda_r,select_next;

always@(negedge clk2)
begin
	sda_r <= sda;
end

always@(select)
begin
	if(select == 1'b0)
	begin
		cmd_mod = 8'h00;
	end
	else
	begin
		cmd_mod = 8'hc0;
	end
end

always@(posedge clk2,negedge reset)
begin
	if(~reset)
	begin
		fsm <= 4'd0;
		add_con <= 4'd7;
		address_7a <= 8'h78;
		address <= 10'd0;
		select <= 1'b0;
		mode <= 2'd0;
	end
	else
	begin
		fsm <= fsm_next;
		address <= address_next;
		add_con <= add_con_next;
		select <= select_next;
		mode <= mode_next;
	end
end

always@(*)
begin
	case(fsm)
		3'd0:		//reset
		begin
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			fsm_next = 3'd1;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
			mode_next = mode;
		end
		3'd1:		//start
		begin
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			fsm_next = 3'd2;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
			mode_next = mode;
		end
		3'd2:		//8bit
		begin
			ctrl_h = 1'b0;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 3'd3;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			case(mode)
				2'd0:
				begin
					sda_w = address_7a[add_con];
				end
				2'd1:
				begin
					sda_w = cmd_mod[add_con];
				end
				2'd2:
				begin
					sda_w = data[add_con];
				end
				default:
				begin
					sda_w = 1'b1;
				end
			endcase
			address_next = address;
			select_next = select;
			mode_next = mode;
		end
		3'd3:		//ack
		begin
			ctrl_h = 1'b0;
			sda_w = 1'b1;
			if(sda_r == 1'b1)
			begin
				fsm_next = 3'd0;
				mode_next = 2'd0;
				address_next = address;
			end
			else
			begin
				if(mode == 2'd2)
				begin
					fsm_next = 3'd4;
					mode_next = 2'd0;
					address_next = address + 10'd1;
				end
				else
				begin
					fsm_next = 3'd2;
					mode_next = mode + 2'd1;
					address_next = address;
				end
			end
			add_con_next = add_con;
			select_next = select;
		end
		3'd4:		//stop1
		begin
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			fsm_next = 3'd5;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
			mode_next = mode;
		end
		3'd5:		//stop2
		begin
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			if(select == 1'b0)
			begin
				fsm_next = 3'd1;
				if(address != 10'd40)
				begin
					select_next = select;
					address_next = address;
				end
				else
				begin
					select_next = 1'b1;
					address_next = 10'd0;
				end
			end
			else
			begin
				select_next = select;
				address_next = address;
				if(address != 10'd1023)
				begin
					fsm_next = 3'd1;
				end
				else
				begin
					fsm_next = 3'd6;
				end
			end
			add_con_next = add_con;
			mode_next = mode;
		end
		default:
		begin
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			fsm_next = fsm;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
			mode_next = mode;
		end
	endcase
end

endmodule
