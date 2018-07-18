module ctrl(
	input reset,clk2,sda,scl,clk1,
	input [7:0]data,
	output reg [9:0]address,
	output reg sda_w,ctrl_d,ctrl_l,ctrl_h,select
);

reg [9:0]address_next;
reg [3:0]fsm,fsm_next;
reg [3:0]add_con,add_con_next;
reg [7:0]address_7a,cmd_mod_c0;
reg sda_r,select_next;

always@(negedge clk2)
begin
	sda_r <= sda;
end

always@(posedge clk2,negedge reset)
begin
	if(~reset)
	begin
		fsm <= 4'd0;
		add_con <= 4'd7;
		address_7a <= 8'h78;
		cmd_mod_c0 <= 8'hc0;
		address <= 10'd0;
		select <= 1'b0;
	end
	else
	begin
		fsm <= fsm_next;
		address <= address_next;
		add_con <= add_con_next;
		select <= select_next;
	end
end

always@(*)
begin
	case(fsm)
		4'd0:		//reset
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 4'd1;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
		end
		4'd1:		//start
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b1;
			fsm_next = 4'd2;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
		end
		4'd2:		//address => 7a
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 4'd3;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = address_7a[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			address_next = address;
			select_next = select;
		end
		4'd3:		//ack    _address => 7a
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 4'd0;
			end
			else
			begin
				fsm_next = 4'd4;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			address_next = address;
			select_next = select;
		end
		4'd4:		//cmd_mode  00
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 4'd5;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			if(select == 1'b0)
			begin
				sda_w = 1'b0;
			end
			else
			begin
				sda_w = cmd_mod_c0[add_con];
			end
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			address_next = address;
			select_next = select;
		end
		4'd5:		//ack    _cmd_mode
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 4'd0;
			end
			else
			begin
				fsm_next = 4'd6;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			address_next = address;
			select_next = select;
		end
		4'd6:		//cmd_data
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 4'd7;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = data[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			address_next = address;
			select_next = select;
		end
		4'd7:		//ack     _cmd
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 4'd0;
				address_next = address;
			end
			else
			begin
				address_next = address + 10'd1;
				fsm_next = 4'd8;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			select_next = select;
		end
		4'd8:		//stop1
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 4'd9;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
		end
		4'd9:		//stop2
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			if(select == 1'b0)
			begin
				fsm_next = 4'd1;
				if(address != 10'd40)
				begin
					select_next = 1'b0;
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
				select_next = 1'b1;
				address_next = address;
				if(address != 10'd1023)
				begin
					fsm_next = 4'd1;
				end
				else
				begin
					fsm_next = 4'd10;
				end
			end
			add_con_next = add_con;
		end
		default:
		begin
			ctrl_d = 1'b0;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			fsm_next = fsm;
			add_con_next = add_con;
			address_next = address;
			select_next = select;
		end
	endcase
end

endmodule
