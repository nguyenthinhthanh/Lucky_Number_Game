`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 02:17:45 PM
// Design Name: 
// Module Name: LuckyNumberGame
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


module LuckyNumberGame(
    input clk,
    input rst,
    input[3:0] button,
    output reg[3:0] led
    //output reg button_pressed_hold
    );
    
    wire clk_out;                               /*This clk for 400Hz - 2.5ms read button*/  
    wire [3:0]led_reg;
    wire [7:0]button_state_wire;
    wire button_pressed_hold_reg;
    
    reg[3:0] led_state;
                                        
    parameter TARGET_CLK_FREQ = 400;            /*For every 10ms read button value */
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );
    
    fsmForButtonState fsm_for_button_state_inst(
        .clk(clk),
        .clk_out(clk_out),
        .rst(rst),
        .button_in(button),
        .button_state(button_state_wire)
    );
    
    toggleLedTop toggle_led_inst(
        .clk(clk_out),
        .rst(rst),
        .led(led_reg),
        .button_state(button_state_wire)
        //.button_pressed_hold(button_pressed_hold_reg)
    );
    
    integer i;
    
    always @(posedge clk_out or posedge rst) begin
        if(rst) begin
           led <= 4'b0000;
        end
        else begin
            for(i=0;i<4;i=i+1) begin
                if(led_reg[i]) begin
                    led[i] <= ~led[i];
                end   
            end
        end
    end
endmodule
