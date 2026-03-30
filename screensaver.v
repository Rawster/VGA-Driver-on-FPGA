module screensaver (
    
    input wire          clk,
    input wire          reset,
    input wire [11:0]   pixel_x,
    input wire [11:0]   pixel_y,
    input wire [11:0]   resolution_height,
    input wire [11:0]   resolution_width,
    input wire          vsync,
    input wire [63:0]   image_bits, //Row data from ROM
     
	
    output reg [7:0]    pixel_r_out,
    output reg [7:0]    pixel_g_out,
    output reg [7:0]    pixel_b_out,
    output reg [5:0]    adress_rom
);

//Register for storing postion of the image
reg [11:0] position_x;
reg [11:0] position_y;
//Direction of image movement
reg dir_x;
reg dir_y;
//Same for image in next frame
reg [11:0] next_position_x;
reg [11:0] next_position_y;
reg next_dir_x;
reg next_dir_y;

reg [11:0] resolution_width_reg;
reg [11:0] resolution_height_reg;
reg vsync_prev = 0;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        resolution_width_reg  <= 0;
        resolution_height_reg <= 0;
    end else begin
        resolution_width_reg  <= resolution_width;
        resolution_height_reg <= resolution_height;
    end
end

//Movement Physics Logic (Bouncing Box)
always @(*) begin
    next_dir_x = dir_x;
	 
	 
	 //detect collisons
    if ((position_x >= resolution_width_reg - 64) && (dir_x == 0)) begin
        next_dir_x = 1;
    end else if ((position_x <= 0) && (dir_x == 1)) begin
        next_dir_x = 0;
    end
    
    next_dir_y = dir_y;
	 
    if ((position_y >= resolution_height_reg - 64) && (dir_y == 0)) begin
        next_dir_y = 1;
    end else if ((position_y <= 0) && (dir_y == 1)) begin
        next_dir_y = 0;
    end
	
    if (next_dir_x == 0) begin
        next_position_x = position_x + 1;
    end else begin
        next_position_x = position_x - 1;
    end
    
    if (next_dir_y == 0) begin
        next_position_y = position_y + 1;
    end else begin
        next_position_y = position_y - 1;
    end
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        position_x <= 100;
        position_y <= 100;
        dir_x      <= 0;
        dir_y      <= 0;
        vsync_prev <= 0;
    end else begin
        vsync_prev <= vsync;
        
       //Reset position if resolution changes
        if (resolution_width_reg != resolution_width) begin
            

                position_x <= 100;
                position_y <= 100;
                dir_x      <= 0;
                dir_y      <= 0;
            
        end 
        //Update position once per frame
        else begin
            if (vsync && !vsync_prev) begin
                position_x <= next_position_x;
                position_y <= next_position_y;
                dir_x      <= next_dir_x;
                dir_y      <= next_dir_y;
            end
        end
    end
end


reg color_bit;
// Pixel Drawing Logic
always @(*) begin
	//Check if current pixel is within the image boundaries
    if ((pixel_x >= position_x) && (pixel_x < position_x + 64) &&
        (pixel_y >= position_y) && (pixel_y < position_y + 64)) 
    begin
		  //Calculate ROM row address
        adress_rom = pixel_y - position_y;
		  //Select bit from 64-bit word  
        color_bit = image_bits[63 - (pixel_x - position_x)];
    end else begin
		  //if not in draw radius, black
        adress_rom = 0;
        color_bit = 1'b0;
    end
end

always @(*) begin
	//Color Mapping
    if (color_bit == 1'b1) begin
        pixel_r_out = 8'hFF; pixel_g_out = 8'hFF; pixel_b_out = 8'hFF;
    end else begin
        pixel_r_out = 8'h00; pixel_g_out = 8'h00; pixel_b_out = 8'h00;
    end
end

endmodule