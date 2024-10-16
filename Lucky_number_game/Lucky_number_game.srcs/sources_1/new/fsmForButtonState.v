`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 11:20:48 AM
// Design Name: 
// Module Name: fsmForButtonState
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
`include "header.vh"

module fsmForButtonState(
    input clk,
    input rst,
    input[3:0] button_in,                           /*This for read button value from Arty-z7*/
    output reg[1:0] button_state0,                  /*This is state for button 0*/
    output reg[1:0] button_state1,                  /*This is state for button 1*/
    output reg[1:0] button_state2,                  /*This is state for button 2*/
    output reg[1:0] button_state3,                  /*This is state for button 3*/
    output reg[3:0] button_read_done                /*This signal for feedback when read done in button*/
    );
    
    wire[3:0] button_press_flag_wire;
    wire[3:0] button_pressed_hold_flag_wire;
    
    wire[1:0] button_state[3:0];
    assign button_state[0] = button_state0;
    assign button_state[1] = button_state1;
    assign button_state[2] = button_state2;
    assign button_state[3] = button_state3;
     
    readButtonWithDebounce read_button_debounce_inst(
    .clk(clk),
    .rst(rst),
    .button_in(button_in),
    .button_press_flag(button_press_flag_wire),
    .button_pressed_hold_flag(button_pressed_hold_flag_wire),
    .button_read_done(button_read_done)
    );
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_state0 <= `BUTTON_STATE_RELEASED;
            button_state1 <= `BUTTON_STATE_RELEASED;
            button_state2 <= `BUTTON_STATE_RELEASED;
            button_state3 <= `BUTTON_STATE_RELEASED;
            
            button_read_done <= 4'b0000;
        end
        else begin
            for(i=0;i<4;i=i+1) begin
                case(button_state[i])
                    `BUTTON_STATE_RELEASED: begin
                        if(button_press_flag_wire[i]) begin
                            if(i==0) begin
                                button_state0 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==1) begin
                                button_state1 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==2) begin
                                button_state2 <= `BUTTON_STATE_PRESSED;
                            end
                            else begin
                                /*i==3*/
                                button_state3 <= `BUTTON_STATE_PRESSED;
                            end
                            button_read_done[i] <= 1;
                        end
                        else begin
                            button_read_done[i] <= 0;
                        end
                    end
                    `BUTTON_STATE_PRESSED: begin
                        if(!button_press_flag_wire[i]) begin
                            if(i==0) begin
                                button_state0 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==1) begin
                                button_state1 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==2) begin
                                button_state2 <= `BUTTON_STATE_PRESSED;
                            end
                            else begin
                                /*i==3*/
                                button_state3 <= `BUTTON_STATE_PRESSED;
                            end
                            button_read_done[i] <= 1;
                        end
                        else begin
                            if(button_pressed_hold_flag_wire[i]) begin
                                if(i==0) begin
                                    button_state0 <= `BUTTON_STATE_PRESSED;
                                end
                                else if(i==1) begin
                                    button_state1 <= `BUTTON_STATE_PRESSED;
                                end
                                else if(i==2) begin
                                    button_state2 <= `BUTTON_STATE_PRESSED;
                                end
                                else begin
                                    /*i==3*/
                                    button_state3 <= `BUTTON_STATE_PRESSED;
                                end
                                button_read_done[i] <= 1;
                            end
                            else begin
                                button_read_done[i] <= 0;
                            end
                        end
                    end
                    `BUTTON_STATE_PRESSED_HOLD: begin
                        if(!button_press_flag_wire[i]) begin
                            if(i==0) begin
                                button_state0 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==1) begin
                                button_state1 <= `BUTTON_STATE_PRESSED;
                            end
                            else if(i==2) begin
                                button_state2 <= `BUTTON_STATE_PRESSED;
                            end
                            else begin
                                /*i==3*/
                                button_state3 <= `BUTTON_STATE_PRESSED;
                            end
                            button_read_done <= 1;
                        end
                        else begin
                            button_read_done <= 0;
                        end                
                    end
                    default: begin
                        if(i==0) begin
                            button_state0 <= `BUTTON_STATE_PRESSED;
                        end
                        else if(i==1) begin
                            button_state1 <= `BUTTON_STATE_PRESSED;
                        end
                        else if(i==2) begin
                            button_state2 <= `BUTTON_STATE_PRESSED;
                        end
                        else begin
                            /*i==3*/
                            button_state3 <= `BUTTON_STATE_PRESSED;
                        end
                        button_read_done[i] <= 0;
                    end
                endcase      
            end
        end    
    end
    
endmodule
