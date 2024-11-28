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
    input [1:0] led_state,
    input led_cur,
    output reg led
    );
    
    /*counter and flag for blinking led*/
    integer counter_b;
    
    
    /*frequency for led blinking*/
    localparam integer FREQ_BLINKY = 200;  
      

    always @(posedge clk or posedge rst)   begin 
        if(rst) begin
            counter_b <= 0;
            led <= 0;
        end
        else    begin
            case(led_state)
                2'b01:  begin
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
                2'b10:  begin
                    if(counter_b < FREQ_BLINKY)    begin
                        counter_b <= counter_b + 1;
                        
                        if(counter_b == FREQ_BLINKY)    begin
                            counter_b <= 0;
                            led <= ~led_cur;
                        end
                    end
                    else    begin
                        counter_b <= 0;
                        led <= ~led_cur;
                    end          
                end
                default: ;
            endcase
        end
    end
endmodule


