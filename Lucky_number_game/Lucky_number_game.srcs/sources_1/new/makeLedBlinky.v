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

/*This module for blinky led*/
module makeLedBlinky(
    input clk,                  /*This is clk from Arty-z7*/
    input rst,                  /*This is reset signal*/
    input [1:0] led_state,      /*This is input led_state for blinky*/
    input led_cur,              /*This is current led index*/
    output reg led              /*This is output led*/
    );
    
    /*Counter and flag for blinking led*/
    integer counter_b;
    
    /*Frequency for led blinking*/
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


