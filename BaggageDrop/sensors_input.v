`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:03 11/06/2021 
// Design Name: 
// Module Name:    sensors_input 
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
module sensors_input(
   output reg [7 : 0]   height,
   input    [7 : 0]   sensor1,
   input    [7 : 0]   sensor2,
   input    [7 : 0]   sensor3,
   input    [7 : 0]   sensor4);
	

	reg [9:0] sum; 
	
	always @(*) begin
		height = 8'b0; 
		sum = 8'b0;
		
		if (sensor1 == 8'b0  || sensor3 == 8'b0) begin
			
			sum = sensor2 + sensor4;
			sum = sum + 8'b1;
			height = sum >> 1;
			
		end else if (sensor2 == 8'b0 || sensor4 == 8'b0) begin
		
			sum = sensor1 + sensor3;
			sum = sum + 8'b1;
			height = sum >> 1;
			
		end else if (sensor1 != 8'b0 && sensor2 != 8'b0 && sensor3 != 8'b0 && sensor4 != 8'b0) begin 
		
			sum = sensor1 + sensor2 + sensor3 + sensor4;
			sum = sum + 8'b0010;
			height = sum >> 2;
			
		end
	end
		
endmodule
