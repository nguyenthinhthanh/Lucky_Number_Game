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
    input[3:0] button_read_done,
    output reg[3:0] button_press_flag,          /*This flag will set when press button*/
    output reg[3:0] button_pressed_hold_flag    /*This flag will set when pressed more
                                                than 500ms*/
    );
    
    wire clk_out;                        /*This clk for 100Hz - 10ms read button*/     
    
    reg[3:0] button_debounce;           /*For store old stable value*/
    reg[3:0] button_debounce0;          /*For debonce value*/
    reg[3:0] button_debounce1;          /*For debonce value*/
    
    reg [3:0] button_read_done_sync;
    
    integer i;
    integer counter_pressed_hold_button[3:0];    /*Counter for 500ms*/   
                                        
    parameter TARGET_CLK_FREQ = 100;   /*100Hz for every 10ms read button value */
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );
    
    always @(posedge clk) begin
        button_read_done_sync <= button_read_done;
    end
    
    /*Reset, read and update button value debounce*/
    always @(posedge clk_out or posedge clk or posedge rst) begin
        if(rst) begin
            button_debounce0 <= 4'b0000;
            button_debounce1 <= 4'b0000;
            button_debounce  <= 4'b0000;
            
            button_press_flag <= 4'b0000;
            button_pressed_hold_flag <=  4'b0000;
            
            for(i=0;i<4;i=i+1) begin
               counter_pressed_hold_button[i] <= 0; 
            end
        end
        else if(clk_out) begin
            /*Read new button value and update debounce value*/
            for(i=0;i< `NUM_OF_BUTTON;i=i+1) begin
                button_debounce0[i] <= button_debounce1[i];
                button_debounce1[i] <= button_in[i];
                
                /*If tow value is same update the button value*/
                if(button_debounce0[i] == button_debounce1[i]) begin
                    if(button_debounce0[i] != button_debounce[i] ) begin
                        /*If new value is diff update vaule*/
                        button_debounce[i] <= button_debounce0[i];
                        
                        if(button_debounce[i] == `BUTTON_PRESSED) begin
                            counter_pressed_hold_button[i] <= `COUNTER_PRESSED_HOLD;
                            button_press_flag[i] <= 1;
                        end
                        else begin
                            button_press_flag[i] <= 0;
                        end    
                    end
                    else begin
                        /*If value is not change that mean
                        press hold so we increase counter value*/
                        counter_pressed_hold_button[i] <= counter_pressed_hold_button[i] - 1;
                        if(counter_pressed_hold_button[i] <= 0) begin
                            counter_pressed_hold_button[i] <= `COUNTER_PRESSED_HOLD;
                            if(button_debounce[i] == `BUTTON_PRESSED) begin
                                button_pressed_hold_flag[i] <= 1;
                            end
                            else begin
                                button_pressed_hold_flag[i] <= 0;
                            end
                        end
                    end
                end
            end
        end
        else begin
            if(clk) begin
               /*If button is read done we clear the flag*/
                for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin 
                    if(button_read_done_sync[i]) begin
                        button_press_flag[i] <= 0;
                        button_pressed_hold_flag[i] <= 0;
                    end
                end 
            end
        end
    end
        
endmodule
