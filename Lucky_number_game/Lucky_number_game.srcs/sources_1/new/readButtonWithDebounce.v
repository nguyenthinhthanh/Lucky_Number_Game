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

/*This is module for debounce button */
module readButtonWithDebounce(
    input clk,                                  /*This is clk from Arty-z7*/
    input clk_button,                           /*This clk for 400Hz - 2.5ms read button*/
    input rst,                                  /*This is reset signal*/
    input[3:0] button_in,                       /*This for read button value from Arty-z7*/
    output[3:0] button_pressed,                 /*This flag will set when press button after debounce*/
    output reg[3:0] button_pressed_hold         /*This flag will set when pressed more after debounce
                                                than 500ms*/
    );
    
    reg[3:0] button_debounce;                   /*Just for debug*/
    reg[3:0] button_pressed_hold_reg;           /*This just reg for store button pressed hole value*/
     
    integer i;                                  /*This integer for travels between buttons*/
    integer counter_pressed_hold_button[3:0];   /*Counter for 500ms*/   
                                        
                                        
    debounceButton debounce_button_0_inst(      /*This module inst for debounce in button 0*/
        .clk(clk_button),                       //  @input : button_in[3:0] from Arty-z7
        .button(button_in[0]),                  // @output : button_pressed after debounce
        .button_pressed(button_pressed[0])
    );
    
    debounceButton debounce_button_1_inst(      /*This module inst for debounce in button 1*/
        .clk(clk_button),                       //  @input : button_in[3:0] from Arty-z7
        .button(button_in[1]),                  // @output : button_pressed after debounce
        .button_pressed(button_pressed[1])
    );
    
    debounceButton debounce_button_2_inst(      /*This module inst for debounce in button 2*/
        .clk(clk_button),                       //  @input : button_in[3:0] from Arty-z7
        .button(button_in[2]),                  // @output : button_pressed after debounce
        .button_pressed(button_pressed[2])
    );
    
    debounceButton debounce_button_3_inst(      /*This module inst for debounce in button 3*/
        .clk(clk_button),                       //  @input : button_in[3:0] from Arty-z7
        .button(button_in[3]),                  // @output : button_pressed after debounce
        .button_pressed(button_pressed[3])
    );
    
   
    /*Reset, read and update button value debounce*/
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_pressed_hold <=  4'b0000;
            button_pressed_hold_reg <= 4'b0000;
            
            for(i=0;i<4;i=i+1) begin
               counter_pressed_hold_button[i] <= 0; 
            end
        end
        else begin
            if(clk) begin   /*This is for button pressed and hold*/
               for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                    if(button_in[i] == `BUTTON_PRESSED) begin
                        /*If pressed and hold more 1000ms, then button is hold*/ 
                        if(counter_pressed_hold_button[i] < `COUNTER_PRESSED_HOLD) begin
                            counter_pressed_hold_button[i] <= counter_pressed_hold_button[i] + 1;
                        end
                        else begin
                            counter_pressed_hold_button[i] <= 0;
                            button_pressed_hold_reg[i] <= 1;
                        end
                    end
                    else begin
                        /*Reset value when button release*/
                        counter_pressed_hold_button[i] <= 0 ;
                        button_pressed_hold_reg[i] <= 0;
                    end
                    /*Update button pressed hold value*/
                    button_pressed_hold[i] <= button_pressed_hold_reg[i];
               end
            end
        end
    end  
endmodule
