`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 04:35:26 PM
// Design Name: 
// Module Name: makeRgbBlinky
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module makeRgbBlinky(
    input clk,
    input rst,
    input rgb_state,
    output reg [5:0] rgb
    );
    
    integer counter_b;
    reg flag_b;
    
    localparam integer FREQ_BLINKY = 200; 
    localparam TURN_ON_LED_CYAN = 6'b110110;   
    localparam TURN_OFF_ALL_LED = 6'b0;         
    
    
    initial begin
        counter_b = 0;      //counter for blinking led
        flag_b = 0;
        rgb = TURN_ON_LED_CYAN;
    end
    always @(posedge clk or posedge rst)   begin 
        if(rst) begin 
            counter_b <= 0;
            flag_b <= 0;
        end      
        else    begin
            case(rgb_state)
                1'b1:   begin
                    if(counter_b < FREQ_BLINKY)    begin
                        counter_b <= counter_b + 1;
                        
                        if(counter_b == FREQ_BLINKY)    begin
                            flag_b <= ~flag_b;
                            counter_b <= 0;
                        end
                    end
                    else    begin
                        flag_b <= ~flag_b;
                        counter_b <= 0;
                    end    
                    
                    if(flag_b)
                        rgb <= TURN_ON_LED_CYAN;
                    else 
                        rgb <= TURN_OFF_ALL_LED;   
                end 
                default: ;   
            endcase
        end
    end
endmodule
