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
    output reg[3:0] led,
    output reg button_pressed_hold
    );
    
    wire[3:0] button_pressed_wire;
    wire[3:0] button_pressed_hold_wire;
    
    reg[3:0] led_state;
    
    readButtonWithDebounce read_button_debounce_inst(
        .clk(clk),
        .rst(rst),
        .button_in(button_in),
        .button_pressed(button_pressed_wire),
        .button_pressed_hold(button_pressed_hold_wire)
    );
    
    integer i;
    reg[3:0] first;
    
    wire clk_out;                               /*This clk for 400Hz - 2.5ms read button*/  
                                        
    parameter TARGET_CLK_FREQ = 400;            /*For every 10ms read button value */
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );
    
    always @(posedge clk_out or posedge rst) begin
        if(rst) begin
            led <= 4'b0000;      
            led_state <= 4'b0000;
            first <= 4'b1111; 
        end
        else begin
            if(clk_out) begin
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
