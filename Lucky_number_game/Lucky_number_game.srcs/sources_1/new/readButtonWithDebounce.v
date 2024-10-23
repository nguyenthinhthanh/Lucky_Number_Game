`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2024 09:12:03 PM
// Design Name: 
// Module Name: readButtonWithDebounce
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

/*This module use for read button signal with resolve debounce problem 
    we will read button signal every 10ms
*/
`include "header.vh"

module readButtonWithDebounce(
    input clk,                                  /*This is clk from Arty-z7*/
    input clk_button,                           /*This clk for 400Hz - 2.5ms read button*/
    input rst,                                  /*This is reset signal*/
    input[3:0] button_in,                       /*This for read button value from Arty-z7*/
    output[3:0] button_pressed,                 /*This flag will set when press button after debounce*/
    output reg[3:0] button_pressed_hold         /*This flag will set when pressed more after debounce
                                                than 500ms*/
    );
    
    reg[3:0] button_debounce;                   /*This is for button pressed hold*/
     
    integer i;
    integer counter_pressed_hold_button[3:0];    /*Counter for 500ms*/   
                                        
    /*parameter TARGET_CLK_FREQ = 400;            *//*For every 10ms read button value *//*
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );*/
    
    debounceButton debounce_button_0_inst(      /*This module inst for debounce in button 0*/
        .clk(clk_button),
        .button(button_in[0]),
        .button_pressed(button_pressed[0])
    );
    
    debounceButton debounce_button_1_inst(      /*This module inst for debounce in button 1*/
        .clk(clk_button),
        .button(button_in[1]),
        .button_pressed(button_pressed[1])
    );
    
    debounceButton debounce_button_2_inst(      /*This module inst for debounce in button 2*/
        .clk(clk_button),
        .button(button_in[2]),
        .button_pressed(button_pressed[2])
    );
    
    debounceButton debounce_button_3_inst(      /*This module inst for debounce in button 3*/
        .clk(clk_button),
        .button(button_in[3]),
        .button_pressed(button_pressed[3])
    );
    
   
    /*Reset, read and update button value debounce*/
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_pressed_hold <=  4'b0000;
            
            for(i=0;i<4;i=i+1) begin
               counter_pressed_hold_button[i] <= 0; 
            end
        end
        else begin
            if(clk) begin
               for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                    if(button_in[i] == `BUTTON_PRESSED) begin
                        if(counter_pressed_hold_button[i] < `COUNTER_PRESSED_HOLD) begin
                            counter_pressed_hold_button[i] <= counter_pressed_hold_button[i] + 1;
                        end
                        else begin
                            counter_pressed_hold_button[i] <= 0;
                            button_pressed_hold[i] <= 1;
                        end
                    end
                    else begin
                        counter_pressed_hold_button[i] <=0 ;
                        button_pressed_hold[i] <= 0;
                    end
               end
            end
        end
    end  
endmodule
