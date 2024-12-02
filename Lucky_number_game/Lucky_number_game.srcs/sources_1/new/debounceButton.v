`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 10:23:11 AM
// Design Name: 
// Module Name: debounceButton
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

/*This module for debounce in button*/
module debounceButton(
    input clk,                      /*This clk for 400Hz - 2.5ms read button*/
    input button,                   /*This for read button value from Arty-z7*/
    output button_pressed           /*This value will set when press button after debounce*/
    );
    
    wire Q0,Q1,Q2,Q2_bar;
    
    my_dff d0(clk, button,Q0 );     /*This is D-flip flop for store value*/
    my_dff d1(clk, Q0,Q1 );         /*This is D-flip flop for store value*/
    my_dff d2(clk, Q1,Q2 );         /*This is D-flip flop for store value*/
    
    assign Q2_bar = ~Q2;
    assign button_pressed = Q1 & Q2_bar;    /*If Q1 = 1 & Q2 = 0,that mean press first time then
                                            Q2 = 1 so we not update value for button */
endmodule
