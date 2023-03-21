`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:10:11 11/27/2021 
// Design Name: 
// Module Name:    maze 
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
module maze #(parameter maze_width = 6,
				parameter state_width = 5,
				parameter direction_width = 3)(
	input 		          clk,
	input [maze_width - 1:0]  starting_col, starting_row, 	// indicii punctului de start
	input  			  maze_in, 			// ofera informa?ii despre punctul de coordonate [row, col]
	output reg [maze_width - 1:0] row, col,	 		// selecteaza un rând si o coloana din labirint
	output reg  maze_oe,			// output enable (activeaza citirea din labirint la rândul ?i coloana date) - semnal sincron	
	output reg  maze_we, 			// write enable (activeaza scrierea în labirint la rândul ?i coloana date) - semnal sincron
	output reg done);				// ie?irea din labirint a fost gasita; semnalul ramane activ 


	`define input_start 5
	
	`define check_direction_to_right 6
	
	`define check_wall_right 7

	`define check_front_wall 9

	`define out 'h11


	reg [state_width - 1:0] current_state, next_state;
	reg [maze_width - 1:0] copy_row, copy_col;
	reg margin; // 0 -> nu am ajuns pe margine sau 1 -> am ajuns pe margine
	reg [direction_width - 1:0] direction; //1 (jos), 2(sus), 3(dreapta), 4(stanga)
	
	

	always@(posedge clk) begin
		if ( done == 0) begin
			current_state <= next_state;
		end
	end
	
	always@(*) begin
		next_state = `input_start;
		done = 0;
		maze_we = 0;
		maze_oe = 0;
		margin = 0; // initial nu am cum sa fiu pe margine
		
		
		// starea de start, salvez pozitia initiala si o marchez
		case(current_state)
			`input_start: begin 
				direction = 1; 
				row = starting_row;
				col = starting_col;
				copy_row = row;
				copy_col = col;
				maze_we = 1;
				next_state = `check_direction_to_right;	
			end
				
		
			`check_direction_to_right: begin
			// imi aleg o directie de deplasare si ma orientez catre dreapta acesteia 
			// pentru a verifica ulterior daca am perete la dreapta
			
			// verific daca ma aflu pe margine
				if ( row == 6'b0 || row == 6'd63 || col == 6'b0 || col == 6'd63 ) begin
					margin = 1; 	
				end else begin
					margin = 0; 
				end
				
				if ( margin == 1 ) begin // am ajuns pe margine, deci am gasit iesirea
					next_state = `out;
					
				end else if ( margin == 0) begin // nu sunt pe margine
					case ( direction ) 
						1: begin 
							copy_col = col;
							col = col - 1; 
						end
						
						2: begin 
							copy_col = col;
							col = col + 1; 
						end
						
						3: begin 
							copy_row = row;
							row = row + 1; 
						end
						
						4: begin
							copy_row = row;
							row = row - 1;
						end
					endcase
					maze_oe = 1; // citesc pozitia la care fac verificarea sa vad daca am perete in dreapta
					next_state = `check_wall_right;
				end
			end
			
			`check_wall_right: begin // verific daca am perete in dreapta
			// daca am perete in dreapta, ma duc sa verific daca am perete in fata
			// daca nu am perete in dreapta, ma rotesc (90grade la dreapta) si verific daca am perete in fata
				case ( direction ) 
					1: begin 
							case ( maze_in ) 
								1: begin // am perete in dreapta 
									col = copy_col;
									copy_row = row;
									row = row + 1; 
								end
								0: begin // nu am perete in dreapta
									direction = 4; 
									copy_col = col;
									copy_row = row; 
								end
							endcase
					end
					
					2: begin 
							case (maze_in) 
								1: begin // am perete in dreapta
									col = copy_col;
									copy_row = row;
									row = row - 1; 
								end
								0: begin // nu am perete in dreapta
									direction = 3; 
									copy_col = col;
									copy_row = row; 
								end
							endcase
					end
					
					3: begin 
							case ( maze_in) 
								1: begin // am perete in dreapta
									row = copy_row;
									copy_col = col;
									col = col + 1; 	
								end
								0: begin // nu am perete in dreapta
									direction = 1; 
									copy_col = col;
									copy_row = row; 
								end
							endcase
					end
					
					4: begin 
							case ( maze_in )
								1: begin // am perete in dreapta
									row = copy_row;
									copy_col = col;
									col = col - 1; 
								end
								0: begin // nu am perete in dreapta
									direction = 2; 
									copy_col = col;
									copy_row = row; 
								end
							endcase
					end
				endcase
				maze_oe = 1; // citesc pozitia pe care fac verificarea sa vad daca am perete in fata
				next_state = `check_front_wall;
			end
			 
			`check_front_wall: begin // verific daca am perete in fata
			// daca nu am perete in fata, ma deplasez in fata un pas, marchez pozitia si reiau verificarile
			// daca am perete in fata ma rotesc(90grade la stanga), salvez pozitia si reiau verificarile
				case(maze_in)
					0: begin // nu am perete in fata
						copy_col = col;
						copy_row = row;
						maze_we = 1; 
						next_state = `check_direction_to_right;
					end
					
					1: begin // am perete in fata
					
						if ( direction == 1 ) begin
							copy_col = col;
							row = copy_row;
							direction = 3; 
						end 
						
						if ( direction == 2 ) begin
							copy_col = col;
							row = copy_row;
							direction = 4; 
						end
						
						if ( direction == 3 ) begin
							copy_row = row;
							col = copy_col;
							direction = 2; 
						end
						
						if ( direction == 4 ) begin
							copy_row = row;
							col = copy_col;
							direction = 1; 
						end
						next_state = `check_direction_to_right;
					end
				endcase
			end
					// am iesit din labirint
					`out: done = 1;

					default ;
			endcase
		end
endmodule
