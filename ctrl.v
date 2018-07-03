module ctrl(
	input reset,clk2,sda,scl,clk1,
	input [7:0]cmd_data,lcd_data,
	output reg [6:0]cmd_address,
	output reg [9:0]lcd_address,
	output reg sda_w,ctrl_d,ctrl_l,ctrl_h
);

reg [6:0]cmd_address_next;
reg [9:0]lcd_address_next;
reg [4:0]fsm,fsm_next;
reg [3:0]add_con,add_con_next;
reg [7:0]address_7a,cmd_mod_c0;
reg sda_r;

always@(negedge clk2)
begin
	sda_r <= sda;
end

always@(posedge clk2,negedge reset)
begin
	if(~reset)
	begin
		fsm <= 4'd0;
		cmd_address <= 7'd0;
		add_con <= 4'd7;
		address_7a <= 8'b01111010;
		cmd_mod_c0 <= 8'hc0;
		lcd_address <= 10'd0;
	end
	else
	begin
		fsm <= fsm_next;
		cmd_address <= cmd_address_next;
		add_con <= add_con_next;
		lcd_address <= lcd_address_next;
	end
end

always@(*)
begin
	case(fsm)
		5'd0:		//reset
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 5'd1;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		5'd1:		//start
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b1;
			fsm_next = 5'd2;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		5'd2:		//address => 7a
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd3;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = address_7a[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd3:		//ack    _address => 7a
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd0;
			end
			else
			begin
				fsm_next = 5'd4;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd4:		//cmd_mode  00
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd5;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd5:		//ack    _cmd_mode
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd0;
			end
			else
			begin
				fsm_next = 5'd6;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd6:		//cmd_data
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd7;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = cmd_data[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd7:		//ack     _cmd
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd0;
				cmd_address_next = cmd_address;
			end
			else
			begin
				cmd_address_next = cmd_address + 7'd1;
				fsm_next = 5'd8;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			lcd_address_next = lcd_address;
		end
		5'd8:		//stop1
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 5'd9;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		5'd9:		//stop2
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			if(cmd_address <= 7'd40)
			begin
				fsm_next = 5'd1;
			end
			else
			begin
				fsm_next = 5'd10;
			end
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		//---------------------------------------------------------------------------------//
		5'd10:		//reset
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 5'd11;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		5'd11:		//start
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b1;
			fsm_next = 5'd12;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next <= lcd_address;
		end
		5'd12:		//address => 7a
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd13;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = address_7a[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd13:		//ack    _address => 7a
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd10;
			end
			else
			begin
				fsm_next = 5'd14;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd14:		//cmd_mode  C0
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd15;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = cmd_mod_c0[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd15:		//ack    _cmd_mode
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd10;
			end
			else
			begin
				fsm_next = 5'd16;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd16:		//LCD_data
		begin
			ctrl_d = 1'b1;
			if(add_con == 4'd0)
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd17;
			end
			else
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			sda_w = lcd_data[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
			lcd_address_next = lcd_address;
		end
		5'd17:		//ack     LCD
		begin
			ctrl_d = 1'b0;
			if(sda_r == 1'b1)
			begin
				fsm_next = 5'd10;
				lcd_address_next <= lcd_address;
			end
			else
			begin
				lcd_address_next <= lcd_address + 10'd1;
				fsm_next = 5'd18;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
		end
		5'd18:		//stop1
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b0;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			fsm_next = 5'd19;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		5'd19:		//stop2
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			if(lcd_address <= 10'd1023)
			begin
				fsm_next = 5'd11;
			end
			else
			begin
				fsm_next = fsm;
			end
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
		default:
		begin
			ctrl_d = 1'b0;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			fsm_next = fsm;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
			lcd_address_next = lcd_address;
		end
	endcase
end

endmodule
