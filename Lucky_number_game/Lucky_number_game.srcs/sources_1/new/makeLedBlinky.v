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
    input [3:0] led_cur,
    output reg [3:0] led
    );
    
    /*counter and flag for blinking led*/
    integer counter_b;
    integer counter_j;
    reg flag_b;
    reg [3:0] led_j;
    
    reg [3:0] led_reg;
    
    /*frequency for led blinking*/
    localparam integer FREQ_BLINKY = 200;  
      

    always @(posedge clk or posedge rst)   begin 
        if(rst) begin 
            counter_b <= 0;
            counter_j <= 0;
            flag_b <= 1;
            led_j <= 4'b0001;
        end      
        else begin
            case(led_state)
            /*State led blinky*/
                2'b01:   begin
                    if(counter_b < FREQ_BLINKY)    begin
                        counter_b <= counter_b + 1;
                        
                        if(counter_b == FREQ_BLINKY)    begin
                            counter_b <= 0;
                            flag_b <= ~flag_b;
                            
                            
                        end
                    end
                    else    begin
                        counter_b <= 0;
                        flag_b <= ~flag_b;
                    end 
                    
                    /*Check flag to change led color*/
                    if(flag_b)
                        led <= 6'b0;
                    else 
                        led <= led_cur;                
                end 
                 /*State led jumping*/
                2'b10:  begin
                /*Check counter to change led color*/
                    if(counter_j < FREQ_BLINKY)    begin
                        counter_j <= counter_j + 1;
                        
                        if(counter_j == FREQ_BLINKY)    begin
                            counter_j <= 0;
                            led <= led_j;
                            led_j <= ((led_j << 1)|led_j[3]);
                        end
                    end
                    else    begin
                        counter_j <= 0;
                        led <= led_j;
                        led_j <= ((led_j << 1)|led_j[3]);
                    end                                           
                end
                default: ;   
            endcase
        end
    end
endmodule

