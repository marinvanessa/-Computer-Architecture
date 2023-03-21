`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:38:05 11/09/2021 
// Design Name: 
// Module Name:    display_and_drop 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module display_and_drop(
    output reg[6:0] seven_seg1,
	 output reg[6:0] seven_seg2,
	 output reg[6:0] seven_seg3,
	 output reg[6:0] seven_seg4,
	 output reg[0:0] drop_activated,
	 input [15:0] t_act,
	 input [15:0] t_lim,
	 input drop_en);
	 
	 always@(*) begin
		if ( drop_en == 0 && t_act < t_lim) begin
			seven_seg1 = 7'b0111001;
			seven_seg2 = 7'b1011100;
			seven_seg3 = 7'b0111000;
			seven_seg4 = 7'b1011110;
			drop_activated = 1'b0;
		end else if (drop_en == 1 && t_act > t_lim) begin
			seven_seg1 = 7'b0;
			seven_seg2 = 7'b1110110;
			seven_seg3 = 7'b1011100;
			seven_seg4 = 7'b1111000;
			drop_activated = 1'b0;
		end else if (drop_en == 1 && t_act <= t_lim) begin
			seven_seg1 = 7'b1011110;
			seven_seg2 = 7'b1010000;
			seven_seg3 = 7'b1011100;
			seven_seg4 = 7'b1110011;
			drop_activated = 1'b1;
		end
	 end
	 


endmodule
