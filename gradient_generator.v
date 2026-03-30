

module gradient_generator (
    input wire          clk,
    input wire          reset,
    input wire [11:0] resolution_height,
	 input wire [11:0] resolution_width,
    input wire [11:0]   pixel_x,

    output reg [7:0]    pixel_r_out,
    output reg [7:0]    pixel_g_out,
    output reg [7:0]    pixel_b_out
);

  
    localparam INC_800   = 3;
    localparam INC_1280  = 5;
    localparam INC_1368  = 5;
    localparam INC_1920  = 7;
	 
    localparam RES_800   = 800;
    localparam RES_1280  = 1280;
    localparam RES_1368  = 1368;
    localparam RES_1920  = 1920;
	 
	 localparam FIT_800   = 24; 
    localparam FIT_1280  = 0;		
    localparam FIT_1368  = 15;  	
    localparam FIT_1920  = 14;   

 
    reg [7:0] increment_val;//Width of a single color band
    reg [11:0] resolution_val; 
	 
	 //Logic to select parameters based on current resolution
    always @(*) begin
        
            if		 (resolution_width == 800 &&  resolution_height == 600) 		begin  increment_val = INC_800;  resolution_val = RES_800; fit_pixels=FIT_800;  end
            else if(resolution_width == 1280 && resolution_height == 720)	begin  increment_val = INC_1280; resolution_val = RES_1280; fit_pixels=FIT_1280; end
            else if(resolution_width == 1368 && resolution_height == 768)	begin  increment_val = INC_1368; resolution_val = RES_1368; fit_pixels=FIT_1368; end
            else if(resolution_width == 1920 && resolution_height == 1080)	begin  increment_val = INC_1920; resolution_val = RES_1920; fit_pixels=FIT_1920; end
            else if(resolution_width == 1280 && resolution_height == 960)	begin  increment_val = INC_1280; resolution_val = RES_1280; fit_pixels=FIT_1280; end
            else begin increment_val = INC_800;  resolution_val = RES_800; fit_pixels=FIT_800;  end
        
    end

    
    reg [7:0] counter;
	 reg [7:0] auto_fit_counter;
    reg [7:0] color_accumulator;//Stores current grayscale intensity (0-255)
	 reg [7:0] fit_pixels;//Extra pixels to adjust gradient width

    always @(posedge clk) begin
        if (reset) begin
            color_accumulator <= 0;
            counter <= 0;
       
        end else begin 
				//reset on end of line
            if (pixel_x == resolution_val-1) begin
                color_accumulator <= 0;
                counter <= 0;
					 auto_fit_counter <= 0;
            end else if (pixel_x < resolution_val) begin
                //Adjustment logic: stretches specific bands to fit screen width perfectly
					if (auto_fit_counter < fit_pixels-1) begin
					
						auto_fit_counter <= auto_fit_counter +1;
						// Standard increment logic
							 if (counter == increment_val-1) begin 
								  color_accumulator <= color_accumulator + 1;
								  counter <= 0;
							 end else begin
								  counter <= counter + 1;
							 end
					
					end
					
					else
						
						auto_fit_counter <= 0;
						
					end

        end
    end
    
   //Assign calculated grayscale value to all channels
    always @(*) begin
        pixel_r_out = color_accumulator;
        pixel_g_out = color_accumulator;
        pixel_b_out = color_accumulator;
    end
endmodule