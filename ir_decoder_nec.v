module ir_decoder_nec (
    
    input wire clk,        
    input wire reset,        
    input wire ir_rx_pin,     
    
    
	 output reg command_repeat,
    output reg [7:0] command_out  
    
);


reg [20:0] seq_counter;//Counter for measuring pulse width
reg [25:0] watchdog;//FSM State
reg [4:0] state;
reg [3:0] bit_counter;//Counter for received bits (0-7)
reg next_bit;

reg [7:0] command;
reg [7:0] command_neg;
reg [7:0] address;
reg [7:0] address_neg;

reg new_bit_start;
reg previous_ir_rx_clean; 
//Active Low sensor
localparam LINE_HIGH = 0;
localparam LINE_LOW = 1;
parameter WIDTH = 8;
localparam TIMEOUT_CYCLES = 200000; 



reg ir_rx_clean;         





always @ (posedge clk or posedge reset) begin

    
    if (reset) begin
       
        seq_counter <= 0;
        watchdog <= 0;
        state <= 0;
        bit_counter <= 0;
        next_bit <= 0;
        command <= 0;
        command_neg <= 0;
        address <= 0;
        address_neg <= 0;
        previous_ir_rx_clean <= LINE_LOW; 
        command_out <= 8'b0;
        
		  ir_rx_clean<=LINE_LOW;
        
		end else begin
			//Signal synchronization
			ir_rx_clean <= ir_rx_pin;
			previous_ir_rx_clean <= ir_rx_clean;
			//NEC Decoder FSM
        case (state)
           //State 0: Idle, waiting for falling edge
            4'd0: begin
						command_repeat <=0;
                
                if ( previous_ir_rx_clean == LINE_LOW && ir_rx_clean == LINE_HIGH ) begin
                    state <= 1;
                    seq_counter <= 0; 
                end
            end

            //State 1: Measure 9ms Start Burst (High)
            4'd1: begin
                if (ir_rx_clean == LINE_HIGH ) begin 
                    seq_counter <= seq_counter + 1;
                end
                
                if (seq_counter > 360000) begin 
                    state <= 2;
                    seq_counter <= 0;
                end
                
               
                if (seq_counter < 360000 && ir_rx_clean == LINE_LOW) begin 
                    state <= 0;
                    seq_counter <= 0;
                end
            end
                
            //State 2: Waiting for 4.5ms Space (Low)
            4'd2: begin
                seq_counter <= 0;
                
                if ( previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW ) begin
                    state <= 3;
                    seq_counter <= 0; 
                end
            end

				//State 3: Detect Repeat Code or Data Start
            4'd3: begin
                if (ir_rx_clean == LINE_LOW ) begin 
                    seq_counter <= seq_counter + 1;
                end
                
                if (seq_counter > 180000 && ir_rx_clean == LINE_HIGH) begin 
							state <= 4; 
							seq_counter <= 0;
							bit_counter <= 0;
							next_bit <= 0;
						  
						  
							command <= 0;
							command_neg <= 0;
							address <= 0;
							address_neg <= 0;
                end
                
                
                if (seq_counter < 180000 && ir_rx_clean == LINE_HIGH) begin 
                    state <= 0;
                    seq_counter <= 0;
						  
                end
                
                
                if (seq_counter > 300000) begin 
                    state <= 0;
                    seq_counter <= 0;
                end
            end
            
            //State 4: Read Address Bits
            4'd4: begin
                if ( previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW && next_bit == 0) begin
                    next_bit <= 1;
                    seq_counter <= 0;
                end

                if (ir_rx_clean == LINE_LOW && next_bit == 1) begin
                    seq_counter <= seq_counter + 1;
                end
                
               
                if (seq_counter > 67200 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    
						  address <= {1'b1,address[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 5;
                    end
                end
                
                
                if (seq_counter > 22400 && seq_counter < 33700 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    address <= {1'b0,address[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 5;
                    end
                end
                

            end

           //State 5: Read Inverted Address
            4'd5: begin
                if ( previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW && next_bit == 0) begin
                    next_bit <= 1;
                    seq_counter <= 0;
                end

                if (ir_rx_clean == LINE_LOW && next_bit == 1) begin
                    seq_counter <= seq_counter + 1;
                end
                
                if (seq_counter > 67200 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    address_neg <= {1'b1,address_neg[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 6;
                    end
                end
                
                if (seq_counter > 22400 && seq_counter < 33700 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    address_neg <= {1'b0,address_neg[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 6;
                    end
                end
                

            end				
                
            //State 6: Read Command Bits
            4'd6: begin
                if ( previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW && next_bit == 0) begin
                    next_bit <= 1;
                    seq_counter <= 0;
                end

                if (ir_rx_clean == LINE_LOW && next_bit == 1) begin
                    seq_counter <= seq_counter + 1;
                end
                
                if (seq_counter > 67200 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    command <= {1'b1,command[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 7;
								
                    end
                end
                
                if (seq_counter > 22400 && seq_counter < 33700 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    command <= {1'b0,command[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 7;
								
                    end
                end
                

            end	

           //State 7: Read Inverted Command and Validate
            4'd7: begin
					
                if ( previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW && next_bit == 0) begin
                    next_bit <= 1;
                    seq_counter <= 0;
                end

                if (ir_rx_clean == LINE_LOW && next_bit == 1) begin
                    seq_counter <= seq_counter + 1;
                end
                
                if (seq_counter > 67200 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    command_neg <= {1'b1,command_neg[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                    watchdog <= 0; 
                    
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 8; 
                        watchdog <= 0;
								
								
                       


                    end
                end
                
                if (seq_counter > 22400 && seq_counter < 33700 && ir_rx_clean == LINE_HIGH && next_bit == 1) begin
                    command_neg <= {1'b0,command_neg[WIDTH-1:1]};
                    next_bit <= 0;
                    seq_counter <= 0;
                    bit_counter <= bit_counter + 1;
                    
                
                    if (bit_counter == 7) begin
                        next_bit <= 0;
                        bit_counter <= 0;
                        state <= 8; 
								watchdog <= 0;
								
                      

                        
                    end
                end
                

            end
				//State 8: Validation and Output
				 4'd8: begin
				 
					 if (previous_ir_rx_clean == LINE_HIGH && ir_rx_clean == LINE_LOW) begin
					 
						state <= 0;
						command_repeat <=1;
						// Check logical inverse to ensure data integrit
						if (command == ~command_neg && address == ~address_neg) begin
						command_out <= command;
						end
					 
					 end
				 
				 end

            default : begin
                state <= 0;         
                seq_counter <= 0;   
                watchdog <= 0;
                bit_counter <= 0;   
                next_bit <= 0;    
            end

        endcase


        

    end 
end 

endmodule