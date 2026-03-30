module grid (
    input wire           clk,
    input wire           reset,
    input wire  [11:0]   resolution_height,
    input wire  [11:0]   resolution_width,
    input wire  [11:0]   pixel_x,
    input wire  [11:0]   pixel_y,

    output reg  [7:0]    pixel_r_out,
    output reg  [7:0]    pixel_g_out,
    output reg  [7:0]    pixel_b_out
);


parameter GRID_SPACING = 64; 
parameter LINE_WIDTH   = 1;   


reg [7:0] color_r, color_g, color_b;


always @(posedge clk) begin

	//Draw Red Border around the screen edges
    if (pixel_x < LINE_WIDTH || pixel_y < LINE_WIDTH || 
        pixel_x >= resolution_width - LINE_WIDTH || 
        pixel_y >= resolution_height - LINE_WIDTH) 
    begin
        color_r <= 255;
        color_g <= 0;
        color_b <= 0;
    end
    
	 //Draw White Grid inside the active area
    // Uses modulo operator to repeat lines every GRID_SPACING pixels
    else if ( (pixel_x % GRID_SPACING < LINE_WIDTH) || 
              (pixel_y % GRID_SPACING < LINE_WIDTH) ) 
    begin
        color_r <= 255;
        color_g <= 255;
        color_b <= 255;
    end

    else begin
        color_r <= 0;
        color_g <= 0;
        color_b <= 0;
    end
end

//output signals
always @(*) begin
    pixel_r_out = color_r;
    pixel_g_out = color_g;
    pixel_b_out = color_b;
end
    
    
endmodule