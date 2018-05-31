module ctrl(
	input reset,clk2,sda,scl,clk1,
	input [7:0]cmd_data,
	output reg [6:0]cmd_address,
	output reg sda_w,ctrl_d,ctrl_l,ctrl_h
);

reg [6:0]cmd_address_next;

reg [4:0]fsm,fsm_next;
reg [3:0]add_con,add_con_next;

reg [7:0]address_7a;

always@(posedge clk2,negedge reset)
begin
	if(~reset)
	begin
		fsm <= 5'd0;
		cmd_address <= 7'd0;
		add_con <= 4'd7;
		address_7a <= 8'b01111010;
	end
	else
	begin
		fsm <= fsm_next;
		cmd_address <= cmd_address_next;
		add_con <= add_con_next;
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
			ctrl_l = 1'b1;
			fsm_next = 5'd1;
			cmd_address_next = cmd_address;
			add_con_next = add_con;
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
		end
		5'd2:		//address => 7a
		begin
			ctrl_d = 1'b1;
			if(add_con > 4'd0)
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			else
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd3;
			end
			sda_w = address_7a[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
		end
		5'd3:		//ack    _address => 7a
		begin
			ctrl_d = 1'b0;
			if(sda == 1'b1)
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
		end
		5'd4:		//cmd_mode
		begin
			ctrl_d = 1'b1;
			if(add_con > 4'd0)
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			else
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd5;
			end
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
		end
		5'd5:		//ack    _cmd_mode
		begin
			ctrl_d = 1'b0;
			if(sda == 1'b1)
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
		end
		5'd6:		//cmd_data
		begin
			ctrl_d = 1'b1;
			if(add_con > 4'd0)
			begin
				add_con_next = add_con - 4'd1;
				fsm_next = fsm;
			end
			else
			begin
				add_con_next = 4'd7;
				fsm_next = 5'd7;
			end
			sda_w = cmd_data[add_con];
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
			cmd_address_next = cmd_address;
		end
		5'd7:		//ack     _cmd_mode
		begin
			ctrl_d = 1'b0;
			if(sda == 1'b1)
			begin
				fsm_next = 5'd0;
				cmd_address_next = cmd_address;
			end
			else
			begin
				cmd_address_next = cmd_address;
				fsm_next = 5'd8;
			end
			add_con_next = add_con;
			sda_w = 1'b0;
			ctrl_h = 1'b0;
			ctrl_l = 1'b0;
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
		end
		5'd9:		//stop2
		begin
			ctrl_d = 1'b1;
			sda_w = 1'b1;
			ctrl_h = 1'b1;
			ctrl_l = 1'b0;
			if(cmd_address < 7'd40)
			begin
				fsm_next = 5'd0;
			end
			else
			begin
				fsm_next = fsm;
			end
			cmd_address_next = cmd_address;
			add_con_next = add_con;
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
		end
	endcase
end

endmodule
