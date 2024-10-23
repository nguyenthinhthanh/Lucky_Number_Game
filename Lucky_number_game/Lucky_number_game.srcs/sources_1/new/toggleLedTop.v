`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 02:39:40 PM
// Design Name: 
// Module Name: toggleLedTop
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


module toggleLedTop(
    input clk_button,                    /*This clk for 400Hz - 2.5ms read button*/
    input rst,                           /*This is reset signal*/
    input[7:0] button_state,             /*This is button state from @fsmForButtonState module*/
    output reg[3:0] led                  /*This is output led*/
    );
    
    reg[3:0] led_state;
    
    integer i;
    
    always @(posedge clk_button or posedge rst) begin
        if(rst) begin
            led <= 4'b0000;      
            led_state <= 4'b0000;
        end
        else begin
            if(clk_button) begin
               for(i=0;i<4;i=i+1) begin
                    if((button_state[i*2 +:2] == `BUTTON_STATE_PRESSED) || (button_state[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD)) begin
                        led_state[i] <= ~led_state[i];
                        //led[i] <= led[i];
                    end
               end 
               led <= led_state;
            end
        end    
    end
    
endmodule
