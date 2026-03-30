

module main (
    input wire          clk,
    input wire          reset,
	 input wire				rx_pin, // IR Receiver input
    
    output wire         vga_hs,
    output wire         vga_vs,
    
    // 4-bit VGA Output
    output wire [3:0]   vga_r,
    output wire [3:0]   vga_g,
    output wire [3:0]   vga_b
);


	 wire [11:0] x_coord; 
    wire [11:0] y_coord; 

    //Color signals (from module control to VGA controller)
    wire [7:0] color_r_wire;
    wire [7:0] color_g_wire;
    wire [7:0] color_b_wire;


    wire [7:0] vga_r_8bit;
    wire [7:0] vga_g_8bit;
    wire [7:0] vga_b_8bit;
	 wire clk_wire;
	 
	 wire [63:0] rom_data; //ROM data for screensaver
	 wire [7:0] y;
	 
	 wire [11:0] resolution_height_wire;
	 wire [11:0] resolution_width_wire;
	 
	 
	 
	 
	 //grid wires
	 wire [7:0] grid_r_wire;
    wire [7:0] grid_g_wire;
    wire [7:0] grid_b_wire;
	 
	 //grid wires
	 wire [7:0] screensaver_r_wire;
    wire [7:0] screensaver_g_wire;
    wire [7:0] screensaver_b_wire;
	 
	 //solidc wires
	 wire [7:0] solidc_r_wire;
    wire [7:0] solidc_g_wire;
    wire [7:0] solidc_b_wire;
	 
	 //gradient wires
	 wire [7:0] gradient_r_wire;
    wire [7:0] gradient_g_wire;
    wire [7:0] gradient_b_wire;
	 
	 //color gradient wires
	 wire [7:0] cgradient_r_wire;
    wire [7:0] cgradient_g_wire;
    wire [7:0] cgradient_b_wire;
	 
	 
	 //command
	 wire [7:0] command_wire;
	 
	 //Module Instantiations
	 
	 image_mem image_mem_inst (
        .address (y),   
        .clock   (selected_clk), 
        .q       (rom_data) 
    );
	 
	 
	 
	grid grid_inst(
	        
        .pixel_x     (x_coord),
		  .pixel_y     (y_coord),
		  .clk			(selected_clk), 
        .pixel_r_out (grid_r_wire),
        .pixel_g_out (grid_g_wire),
        .pixel_b_out (grid_b_wire),
		  .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire)
	); 
	 
	 
	 screensaver screensaver_inst(
        
        .pixel_x     (x_coord),
		  .pixel_y     (y_coord),
		  .clk			(selected_clk), 
		  .image_bits 	(rom_data),
		  .adress_rom 	(y),
        
        .pixel_r_out (screensaver_r_wire),
        .pixel_g_out (screensaver_g_wire),
        .pixel_b_out (screensaver_b_wire),
		  .vsync(vga_vs_driver),
		  .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire)
	 );
	 
	 
    
   
    color_generator color_gen_inst (
        .previous_color(previous_color_wire),
		  .next_color(next_color_wire),
        .pixel_r_out  (solidc_r_wire),
        .pixel_g_out  (solidc_g_wire),
        .pixel_b_out  (solidc_b_wire),
		  .clk(clk)
    );

 
    vga_controller vga_ctrl_inst (
        .clk        (selected_clk),
        .reset      (reset),
        .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire),
        .red_in     (color_r_wire),
        .green_in   (color_g_wire),
        .blue_in    (color_b_wire),
        .vga_hs     (vga_hs),
        .vga_vs     (vga_vs),
		  .vga_hs_driver     (vga_hs_driver),
        .vga_vs_driver     (vga_vs_driver),
		  .pixel_x (x_coord),
		  .pixel_y (y_coord),
        
        
        .vga_r      (vga_r_8bit),
        .vga_g      (vga_g_8bit),
        .vga_b      (vga_b_8bit)
    );
	 
	 display_clock display_clock_inst (
	 
		.refclk (clk),
		
		.outclk_0 (clk0), // outclk0.clk
		.outclk_1 (clk1), // outclk1.clk
		.outclk_2 (clk2),// outclk2.clk
		.outclk_3 (clk3),// outclk3.clk
		.outclk_4 (clk4)// outclk4.clk
	 
	 );
	 
	     clock_selector clock_selector_inst (
        .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire),
        .clk_40M    (clk0),
        .clk_74M    (clk1),
        .clk_85M    (clk2), 
        .clk_148M   (clk3),
        .clk_108M   (clk4),
        .clk_out    (selected_clk)
    );
	 
    gradient_generator grad_gen_inst (
        .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire),
        .pixel_x     (x_coord),
		  .clk			(selected_clk), 
        .pixel_r_out (gradient_r_wire),
        .pixel_g_out (gradient_g_wire),
        .pixel_b_out (gradient_b_wire)
    ); 
	 
	 
	     color_gradient_generator color_grad_gen_inst (
        .resolution_height(resolution_height_wire),
		  .resolution_width(resolution_width_wire),
        .pixel_x     (x_coord),
		  .clk			(selected_clk), 
        .pixel_r_out (cgradient_r_wire),
        .pixel_g_out (cgradient_g_wire),
        .pixel_b_out (cgradient_b_wire)
    );

		resolution_selector resolution_selector_inst(
		.clk(clk),
		.next_resolution(next_resolution_wire),
		.previous_resolution(previous_resolution_wire),
		.resolution_height(resolution_height_wire),
		.resolution_width(resolution_width_wire)
		);
		
		
	module_control module_control_inst(
		.command(command_wire),
		.clk(clk),
		.command_repeat(command_repeat_wire),
		
			 
		.grid_r(grid_r_wire),
		.grid_g(grid_g_wire),
		.grid_b(grid_b_wire),
		
		
		.screensaver_r(screensaver_r_wire),
		.screensaver_g(screensaver_g_wire),
		.screensaver_b(screensaver_b_wire),
		
		
		.solidc_r(solidc_r_wire),
		.solidc_g(solidc_g_wire),
		.solidc_b(solidc_b_wire),
		
		
		.gradient_r(gradient_r_wire),
		.gradient_g(gradient_g_wire),
		.gradient_b(gradient_b_wire),
		
		
		.cgradient_r(cgradient_r_wire),
		.cgradient_g(cgradient_g_wire),
		.cgradient_b(cgradient_b_wire),
		
		.color_r(color_r_wire),
		.color_g(color_g_wire),
		.color_b(color_b_wire),
		
		.next_color(next_color_wire),
		.previous_color(previous_color_wire),
		
		.next_resolution(next_resolution_wire),
		.previous_resolution(previous_resolution_wire)
		
		

		);
		
		
		
ir_decoder_nec ir_decoder_nec_inst(

    .clk(clk),               
    .ir_rx_pin(rx_pin),
	 .command_repeat(command_repeat_wire),	 
    .command_out(command_wire)  


);
	 
	 

	//Truncate 8-bit color to 4-bit for VGA DAC
    assign vga_r = vga_r_8bit[7:4];
    assign vga_g = vga_g_8bit[7:4];
    assign vga_b = vga_b_8bit[7:4];

endmodule