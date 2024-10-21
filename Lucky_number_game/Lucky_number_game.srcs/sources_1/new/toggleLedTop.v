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
    input clk,
    input rst,
    input[7:0] button_state,
    output reg[3:0] led,
    output reg button_pressed_hold
    );
    
    wire[3:0] button_pressed_wire;
    wire[3:0] button_pressed_hold_wire;
    
    reg[3:0] led_state;
    

   
    integer i;
    reg[3:0] first;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led <= 4'b0000;      
            led_state <= 4'b0000;
            first <= 4'b1111; 
        end
        else begin
            if(clk) begin
                button_pressed_hold <= button_pressed_hold_wire[0];
            
               for(i=0;i<4;i=i+1) begin
                    if(button_pressed_wire[i] || button_pressed_hold_wire[i]) begin
                        first[i] <= 0;
                        led_state[i] <= ~led_state[i];
                        //led[i] <= led[i];
                    end
                end 
                led <= led_state;
            end
        end    
    end
    
endmodule
