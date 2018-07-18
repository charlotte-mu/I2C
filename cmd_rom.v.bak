module cmd_rom(
	//input ck,reset,
	input [6:0]address,
	output [7:0]data_out
);

reg [7:0]rom[40:0];

assign data_out = rom[address];

initial
begin
	rom[0]  <= 8'hae;
	rom[1]  <= 8'h20;
	rom[2]  <= 8'h01;
	rom[3]  <= 8'hb0;
	rom[4]  <= 8'hc8;
	rom[5]  <= 8'h0;
	rom[6]  <= 8'h20;
	rom[7]  <= 8'h40;
	rom[8]  <= 8'h81;
	rom[9]  <= 8'hff;
	rom[10] <= 8'ha1;
	rom[11] <= 8'ha6;
	rom[12] <= 8'ha8;
	rom[13] <= 8'h3f;
	rom[14] <= 8'ha4;
	rom[15] <= 8'hd3;
	rom[16] <= 8'h0;
	rom[17] <= 8'hd5;
	rom[18] <= 8'hf0;
	rom[19] <= 8'hd9;
	rom[20] <= 8'h22;
	rom[21] <= 8'hda;
	rom[22] <= 8'h12;
	rom[23] <= 8'hdb;
	rom[24] <= 8'h30;
	rom[25] <= 8'h8d;
	rom[26] <= 8'h14;
	rom[27] <= 8'haf;
	rom[28] <= 8'h80;
	rom[39] <= 8'h0;
	rom[30] <= 8'h80;
	rom[31] <= 8'h20;
	rom[32] <= 8'h80;
	rom[33] <= 8'h40;
	rom[34] <= 8'h20;
	rom[35] <= 8'h1;
	rom[36] <= 8'h21;
	rom[37] <= 8'h0;
	rom[38] <= 8'h7f;
	rom[39] <= 8'h40;
	rom[40] <= 8'h0;
end

endmodule
