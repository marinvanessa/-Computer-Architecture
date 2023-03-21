`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:40:18 11/09/2021 
// Design Name: 
// Module Name:    baggage_drop 
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
module baggage_drop(
    output [6:0] seven_seg1,
	 output [6:0] seven_seg2,
	 output [6:0] seven_seg3,
	 output [6:0] seven_seg4,
	 output [0:0] drop_activated,
	 input [7:0] sensor1,
	 input [7:0] sensor2,
	 input [7:0] sensor3,
	 input [7:0] sensor4,
	 input [15:0] t_lim,
	 input drop_en);
	 
	 
	 //legatura pentru sensors_input
	  wire[7:0] my_height;
	 
	 //legatura sensors_input -> sqrt
	  wire[15:0] my_sqrt;
	  
	  //legatura sqrt -> dad
	   wire [15:0] out_my_sqrt;
	 
	 sensors_input modul_sensors(
		.sensor1(sensor1),
		.sensor2(sensor2),
		.sensor3(sensor3),
		.sensor4(sensor4),
		.height(my_height)
	 );
	 
	 
	 square_root modul_sqrt(
		.in(my_height),
		.out(my_sqrt)
	 );
	 
	 assign out_my_sqrt = my_sqrt >> 1;
	 

	 display_and_drop modul_dd(
		.seven_seg1(seven_seg1),
		.seven_seg2(seven_seg2),
		.seven_seg3(seven_seg3),
		.seven_seg4(seven_seg4),
		.drop_activated(drop_activated),
		.t_act(out_my_sqrt),
		.t_lim(t_lim),
		.drop_en(drop_en)
	 );
	 

endmodule
