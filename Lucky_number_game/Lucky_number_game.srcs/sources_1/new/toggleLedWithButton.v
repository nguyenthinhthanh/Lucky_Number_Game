`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 11:48:16 AM
// Design Name: 
// Module Name: toggleLedWithButton
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


module toggleLedWithButton(
    input clk,
    input rst,
    input[3:0] button_in,
    input[3:0] button_press_flag,
    input[3:0] button_pressed_hold_flag,
    output reg[3:0] button_read_done,
    output reg[3:0] led
    );
    
    readButtonWithDebounce read_button_debounce_inst(
        .clk(clk),
        .rst(rst),
        .button_in(button_in),
        .button_press_flag(button_press_flag),
        .button_pressed_hold_flag(button_pressed_hold_flag),
        .button_read_done(button_read_done)
    );
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led <= 4'b0000;
            button_read_done <= 4'b0000;
        end
        else begin
            for(i=0;i<4;i=i+1) begin
                if(button_press_flag[i] || button_pressed_hold_flag[i]) begin
                    led[i] <= ~led[i];
                    button_read_done[i] <= 1;
                end
                else begin
                    led[i] <= 0;
                    button_read_done <= 0;
                end
            end
        end    
    end
    
endmodule
