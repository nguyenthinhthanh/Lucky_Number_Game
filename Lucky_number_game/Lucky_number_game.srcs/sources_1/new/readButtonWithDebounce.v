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

/*This module use for read button signal with resolve debounce problem */
`include "header.vh"

module readButtonWithDebounce(
    input clk,
    input rst,
    input[3:0] button_in,
    output reg[3:0] button_debounce,
    output reg[3:0] button_pressed_hold
    );
    
    wire clk_out;                        /*This clk for 100Hz - 10ms read button*/
    
    reg[3:0] button_debounce0;          /*For debonce value*/
    reg[3:0] button_debounce1;          /*For debonce value*/
    
    reg[3:0] pressed_hold_flag;         /*This flag will set when pressed more
                                        than 500ms*/
    integer i;
    integer counter_pressed_button[3:0] = {0,0,0,0}; /*Counter for 500ms*/   
                                        
    parameter TARGET_CLK_FREQ = 100;   /*100Hz for every 10ms read button value */
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );
    
    /*Reset, read and update button value debounce*/
    always @(posedge clk_out or posedge rst) begin
        if(rst) begin
            button_debounce0 <= 4'b0000;
            button_debounce1 <= 4'b0000;
            
            pressed_hold_flag <=  4'b0000;
        end
        else begin
            /*Read new button value and update debounce value*/
            for(i=0;i< `NUM_OF_BUTTON;i=i+1) begin
                button_debounce0[i] <= button_debounce1[i];
                button_debounce1[i] <= button_in[i];
                
                if(button_debounce0[i] == button_debounce1[i]) begin
                    /*If tow value is same update the button value*/
                    button_debounce[i] = button_debounce0[i];
                    
                    if(button_debounce[i] == `BUTTON_PRESSED) begin
                        /*If button is pressed check just press
                        or press hold*/
                        if(counter_pressed_button[i] < `COUNTER_PRESSED_HOLD) begin
                            counter_pressed_button[i] <= counter_pressed_button[i] + 1;
                        end
                        else begin
                            pressed_hold_flag[i] <= 1;
                        end
                    end
                    else begin
                        counter_pressed_button[i] <= 0;
                        pressed_hold_flag[i] <= 0;
                    end
                end
            end
        end
    end
        
endmodule
