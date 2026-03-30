

module color_generator (
    input wire  			next_color,
	 input wire				previous_color,
	 input wire				clk,
    

    output reg  [7:0]   pixel_r_out,
    output reg  [7:0]   pixel_g_out,
    output reg  [7:0]   pixel_b_out
);

reg [2:0] color_select; //Color index counter


    always @(*) begin
	 

	 
	 
	 //Output logic: Map index to RGB values
        case (color_select)
           
            3'b000: begin pixel_r_out=8'hFF; pixel_g_out=8'hFF; pixel_b_out=8'hFF; end // black
            3'b001: begin pixel_r_out=8'hFF; pixel_g_out=8'h00; pixel_b_out=8'h00; end // red
            3'b010: begin pixel_r_out=8'h00; pixel_g_out=8'hFF; pixel_b_out=8'h00; end // green
            3'b011: begin pixel_r_out=8'h00; pixel_g_out=8'h00; pixel_b_out=8'hFF; end // blue
            3'b100: begin pixel_r_out=8'hFF; pixel_g_out=8'hFF; pixel_b_out=8'h00; end // yellow
            3'b101: begin pixel_r_out=8'h00; pixel_g_out=8'hFF; pixel_b_out=8'hFF; end // cyan
            3'b110: begin pixel_r_out=8'hFF; pixel_g_out=8'h00; pixel_b_out=8'hFF; end // magenta
            3'b111: begin pixel_r_out=8'h00; pixel_g_out=8'h00; pixel_b_out=8'h00; end  // white
            default: begin pixel_r_out=8'hFF; pixel_g_out=8'hFF; pixel_b_out=8'hFF; end
        endcase
    end
	 
	 always @(posedge clk) begin
	 
	 	if (next_color) color_select <= color_select+1;
		if (previous_color) color_select <= color_select-1;
	 
	 end
	 

endmodule