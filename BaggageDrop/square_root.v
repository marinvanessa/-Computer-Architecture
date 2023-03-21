`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:49:25 11/08/2021 
// Design Name: 
// Module Name:    square_root 
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
module square_root(
	output reg[15:0] out,
	input [7:0] in);

	
	parameter my_width = 16;
		
	reg[my_width-1:0] precision; 
	reg[my_width-1:0] L;   
	reg[my_width-1:0] base;  
	reg[my_width-1:0] copy_out; 
	
	reg[4:0] i; 
	reg[31:0] new_in;
	
	
	always@(*) begin
	
		precision = 16'd16;
		L = precision - 1;
		base = 16'd2 ** L;
		copy_out = 16'b0; 
		out = 16'b0;
		
		/*deoarece intervalul in care se afla inputul este foarte sensibil
		il modificam, inmultindu-l cu 2 la puterea 16, adica precizia pe care ne-o dorim*/
		
		new_in = in * (16'd2 ** precision);
		
		//CORDIC
		for (i = 1; i <= 16; i = i + 1) begin
		
			copy_out = copy_out + base;
			
			if ((copy_out * copy_out) > new_in) begin
				copy_out = copy_out - base;
			end
			
			base = base >> 1;	
		end
		out = copy_out;
	end
	
endmodule
