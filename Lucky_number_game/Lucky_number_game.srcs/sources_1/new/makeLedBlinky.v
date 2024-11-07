`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 01:36:26 AM
// Design Name: 
// Module Name: makeLedBlinky
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
`include "header.vh"

module makeLedBlinky(
    input clk,
    input rst,
    input led_state,
    output reg [3:0] led
    );
    
    integer counter_b;
    localparam integer FREQ_BLINKY = 200; 
    
    initial begin
        counter_b = 0;      //counter for blinking led
        led = 4'b1111;
    end
    always @(posedge clk or posedge rst)   begin 
        if(rst) begin 
            counter_b <= 0;
        end      
        else    begin
            case(led_state)
                1'b1:   begin
                    if(counter_b < FREQ_BLINKY)    begin
                        counter_b <= counter_b + 1;
                        
                        if(counter_b == FREQ_BLINKY)    begin
                            counter_b <= 0;
                            led <= ~led;
                        end
                    end
                    else    begin
                        counter_b <= 0;
                        led <= ~led;
                    end             
                end 
                default: ;   
            endcase
        end
    end
endmodule
