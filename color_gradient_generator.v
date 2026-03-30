

module color_gradient_generator (
    input wire          clk,
    input wire          reset,
    input wire [11:0]   pixel_x,
	 input wire [11:0]   resolution_height,
    input wire [11:0]   resolution_width,

    output reg [7:0]    pixel_r_out,
    output reg [7:0]    pixel_g_out,
    output reg [7:0]    pixel_b_out
);

   //Parameters for gradient scaling (Increment and Fit values)
    localparam INC_800   = 1; localparam FIT_800   = 4;
    localparam INC_1280  = 1; localparam FIT_1280  = 255;
    localparam INC_1368  = 1; localparam FIT_1368  = 14;
    localparam INC_1920  = 1; localparam FIT_1920  = 2;
	 
    localparam RES_800   = 800; localparam RES_1280  = 1280;
    localparam RES_1368  = 1368; localparam RES_1920  = 1920;
	 
  
    reg [7:0] increment_val;
    reg [11:0] resolution_val;
    reg [7:0] fit_pixels;
	//Select parameters based on resolution
    always @(*) begin
        
            if(resolution_width == 800 &&  resolution_height == 600) begin  increment_val=INC_800;  resolution_val=RES_800;  fit_pixels=FIT_800;  end
            else if(resolution_width == 1280 && resolution_height == 720) begin  increment_val=INC_1280; resolution_val=RES_1280; fit_pixels=FIT_1280; end
            else if(resolution_width == 1368 && resolution_height == 768) begin  increment_val=INC_1368; resolution_val=RES_1368; fit_pixels=FIT_1368; end
            else if(resolution_width == 1920 && resolution_height == 1080) begin increment_val=INC_1920; resolution_val=RES_1920; fit_pixels=FIT_1920; end
            else if(resolution_width == 1280 && resolution_height == 960) begin  increment_val=INC_1280; resolution_val=RES_1280; fit_pixels=FIT_1280; end
            else begin increment_val=INC_800;  resolution_val=RES_800;  fit_pixels=FIT_800;  end
        
    end


    reg [7:0] counter;
    reg [7:0] auto_fit_counter;
    reg [7:0] color_r, color_g, color_b;
    reg [2:0] color_phase; //State variable for the color transition FSM

    always @(posedge clk) begin
        if (reset) begin
            color_r<=255; color_g<=0; color_b<=0; counter<=0; auto_fit_counter<=0; color_phase<=0;
        end else begin 
            if (pixel_x == resolution_val-1) begin
                color_r<=255; color_g<=0; color_b<=0; counter<=0; auto_fit_counter<=0; color_phase<=0;
            end else if (pixel_x < resolution_val) begin
                
       
               //smaller resolutions
                if (resolution_val < 1275) begin
                    if (auto_fit_counter <= fit_pixels) begin
                        auto_fit_counter <= auto_fit_counter + 1;
								//When counter reaches threshold, update color
                        if (counter >= increment_val - 1) begin
                            counter <= 0;
                            //State machine for color transitions
                            case(color_phase)
                                3'b000: begin if(color_g>=254) begin color_g<=255; color_phase<=1; end else color_g<=color_g+2; end
                                3'b001: begin if(color_r<=1)   begin color_r<=0;   color_phase<=2; end else color_r<=color_r-2; end
                                3'b010: begin if(color_b>=254) begin color_b<=255; color_phase<=3; end else color_b<=color_b+2; end
                                3'b011: begin if(color_g<=1)   begin color_g<=0;   color_phase<=4; end else color_g<=color_g-2; end
                                3'b100: begin if(color_r>=254) begin color_r<=255; color_phase<=0; end else color_r<=color_r+2; end
                                
                            endcase
                        end else begin
                            counter <= counter + 1;
                        end
                    end else begin
                        auto_fit_counter <= 0;
                    end
                end 
               //bigger resolutions
                else begin
                    if (auto_fit_counter <= fit_pixels) begin
                        auto_fit_counter <= auto_fit_counter + 1;
                        if (counter >= increment_val - 1) begin
                            counter <= 0;
                           
                            case(color_phase)
                                3'b000: begin if(color_g==255) color_phase<=1; else color_g<=color_g+1; end
                                3'b001: begin if(color_r==0)   color_phase<=2; else color_r<=color_r-1; end
                                3'b010: begin if(color_b==255) color_phase<=3; else color_b<=color_b+1; end
                                3'b011: begin if(color_g==0)   color_phase<=4; else color_g<=color_g-1; end
                                3'b100: begin if(color_r==255) color_phase<=0; else color_r<=color_r+1; end
                                
                            endcase
                        end else begin
                            counter <= counter + 1;
                        end
                    end else begin
                        auto_fit_counter <= 0;
                    end
                end
            end
        end
    end
    
    always @(*) begin
        pixel_r_out = color_r;
        pixel_g_out = color_g;
        pixel_b_out = color_b;
    end
endmodule