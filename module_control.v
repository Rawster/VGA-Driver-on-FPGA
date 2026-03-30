module module_control(
input wire clk,
input wire [7:0] command,
input wire command_repeat,

//grid
input wire [7:0] grid_r,
input wire [7:0] grid_g,
input wire [7:0] grid_b,

//screensaver
input wire [7:0] screensaver_r,
input wire [7:0] screensaver_g,
input wire [7:0] screensaver_b,

//solid color
input wire [7:0] solidc_r,
input wire [7:0] solidc_g,
input wire [7:0] solidc_b,

//gradient color
input wire [7:0] gradient_r,
input wire [7:0] gradient_g,
input wire [7:0] gradient_b,

//color gradient color
input wire [7:0] cgradient_r,
input wire [7:0] cgradient_g,
input wire [7:0] cgradient_b,

//out colors
output reg [7:0] color_r,
output reg [7:0] color_g,
output reg [7:0] color_b,

//colors control
output reg next_color,
output reg previous_color,

//resolution control
output reg next_resolution,
output reg previous_resolution



);


reg [7:0] previous_command;
reg [2:0] selected_module = 3'b000;


always @(posedge clk) begin
		previous_command <= command;
		//Detect new command 
		if (previous_command !== command) begin
		//Module Selection (Keys 1-5) 
			if (command == 8'b00001100) selected_module <= 0; //solid color
			if (command == 8'b00011000) selected_module <= 1; //grid 
			if (command == 8'b01011110) selected_module <= 2; //gradient 
			if (command == 8'b00001000) selected_module <= 3; //color gradient
			if (command == 8'b00011100) selected_module <= 4; //screensaver
			
		//Color Control (Left/Right Arrows)
			if (command == 8'b01000000) previous_color <= 1;
			if (command == 8'b01000011) next_color <=1;
			
		//Resolution Control (Up/Down Volume)	
			if (command == 8'b00010101) previous_resolution <= 1;
			if (command == 8'b00001001) next_resolution <= 1;
		
		end
		//Repeat Code Handling
		else if (command == 8'b01000000 && command_repeat) begin
			previous_color <= 1;
		end
		
		
		else if (command == 8'b01000011 && command_repeat) begin
			next_color <= 1;
		end
		
		else if (command == 8'b00010101 && command_repeat) begin
			previous_resolution <= 1;
		end
		
		
		else if (command == 8'b00001001 && command_repeat) begin
			next_resolution <= 1;
		end

		else begin
		// Reset control signals
			next_color <= 0;
			previous_color <= 0;
			previous_resolution <= 0;
			next_resolution <= 0;
		end
		
		
	
end

always @(*) begin


		// Output Multiplexer
		case(selected_module)
			3'b000: begin
			color_r <= solidc_r;
			color_b <= solidc_g;
			color_g <= solidc_b;
			end
			
			3'b001: begin
			color_r <= grid_r;
			color_b <= grid_g;
			color_g <= grid_b;
			end
			
			3'b010: begin
			color_r <= gradient_r;
			color_b <= gradient_g;
			color_g <= gradient_b;
			end
			
			3'b011: begin
			color_r <= cgradient_r;
			color_b <= cgradient_g;
			color_g <= cgradient_b;
			end
			
			3'b100: begin
			color_r <= screensaver_r;
			color_b <= screensaver_g;
			color_g <= screensaver_b;
			end
		endcase	
			
			


end

endmodule