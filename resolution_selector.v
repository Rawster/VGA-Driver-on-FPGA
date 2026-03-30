module resolution_selector(

input clk,

output reg [11:0] resolution_height,
output reg [11:0] resolution_width,

input wire next_resolution,
input wire previous_resolution


);

reg [2:0] resolution; //Current resolution

	always @(posedge clk) begin
		//Next resolution logic (Wrap-around 4 -> 0)
		if (next_resolution && resolution == 4) resolution <= 0;
		else if (next_resolution) resolution <= resolution +1;
		//Previous resolution logic (Wrap-around 0 -> 4)
		if (previous_resolution && resolution == 0) resolution <=4; 
		else if (previous_resolution) resolution <= resolution -1;
	
	end


	//Resolution Table
    always @(*) begin
        case(resolution)
            3'b000: begin resolution_width = 800;  resolution_height = 600;  end
            3'b001: begin resolution_width = 1280; resolution_height = 720;  end
            3'b010: begin resolution_width = 1368; resolution_height = 768;  end
            3'b011: begin resolution_width = 1920; resolution_height = 1080; end
            3'b100: begin resolution_width = 1280; resolution_height = 960;  end
            default:begin resolution_width = 1280; resolution_height = 720;  end
        endcase
    end




endmodule