`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 09:24:41 PM
// Design Name: 
// Module Name: fsmForLuckyNumberGame
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

/*This module is fsm for all state in whole system
    another module just read state or output configuration from here
    to do action corresponding to the state
    */
`include "header.vh"

module fsmForLuckyNumberGame(
    input clk_button,
    input rst,
    input [1:0] switch,
    input [2:0] result_state,
    input [7:0] button_state,
    output reg game_straight,
    output reg type_of_straight,
    output reg control_mode,
    output reg [2:0] game_mode,
    output reg [7:0] fsm_state
    );
    
    
    /*Setting_mode                          Play_mode          
    BTN0 : To change mode                   BTN0 : To play
    BTN1 : To next setting                  BTN1 : To "Yes"
    BTN2 : To back setting previous         BTN2 : To "No"
    BTN3 : To reset setiing                 BTN3 : To play again
    */
    always @(posedge clk_button or posedge rst) begin
        if(rst) begin
            game_straight <= `GAME_NO_STRAIGHT;             /*Default game is no have straight*/
            type_of_straight <= `GAME_STRAIGHT_INC;         /*Just don't care because game no straight default*/
            control_mode <= `GAME_CONTROL_SETTING_MODE;     /*Default control mode is setting mode*/ 
            game_mode <= `GAME_MODE_0;                      /*Default mode is 0*/
            
            fsm_state <= `FSM_STATE_SET_MODE_0;             /*This is init state*/
        end
        else begin
            if(clk_button) begin
                case(fsm_state)
                    /********************Begin state setting game mode********************/
                    `FSM_STATE_SET_MODE_0: begin    /*State 0*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            fsm_state <= `FSM_STATE_SET_MODE_1;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            fsm_state <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state <= `FSM_STATE_SET_MODE_0;
                        end
                    end
                    `FSM_STATE_SET_MODE_1: begin    /*State 1*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            fsm_state <= `FSM_STATE_SET_MODE_2;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            fsm_state <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state <= `FSM_STATE_SET_MODE_1;
                        end
                    end
                    `FSM_STATE_SET_MODE_2: begin    /*State 2*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            fsm_state <= `FSM_STATE_SET_MODE_3;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            fsm_state <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state <= `FSM_STATE_SET_MODE_2;
                        end
                    end
                    `FSM_STATE_SET_MODE_3: begin    /*State 3*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            fsm_state <= `FSM_STATE_SET_MODE_0;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            fsm_state <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state <= `FSM_STATE_SET_MODE_3;
                        end
                    end
                    /********************Done state setting game mode********************/
                    
                    /********************Begin state setting game straight********************/
                    `FSM_STATE_SET_NO_STRAIGHT: begin    /*State 5,12,19,26*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game straight*/
                            fsm_state <= `FSM_STATE_SET_STRAIGHT;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game straight and 
                              next finish setting mode*/
                            fsm_state <= `FSM_STATE_NO_STRAIGHT_PLAY;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 pressed to back previous step*/
                            fsm_state <= `FSM_STATE_SET_MODE_0;
                        end
                        else if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                            /*BTN3 pressed to reset all setting before*/
                            fsm_state <= `FSM_STATE_SET_MODE_0;
                        end
                        else begin
                            /*No change state*/
                            fsm_state <= `FSM_STATE_SET_MODE_2;
                        end
                    end
                    
                    /********************Done state setting game straight********************/
                endcase
            end
        end
    end
endmodule
