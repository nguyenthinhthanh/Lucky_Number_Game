`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 12:52:10 PM
// Design Name: 
// Module Name: resultChecker
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

module resultChecker(
    input clk_system,                      /*This is clock on Arty-z7*/
    input rst,                      /*This is reset signal*/
    input game_straight,            /*This is game play have straight to win or not*/
    input type_of_straight,         /*This is straight increase or decrease*/
    input[1:0] play_again,          /*This is button value when want to play again*/
    input[2:0] game_mode,           /*This is game mode from @fsmForLuckyNumberGame module*/
    input[15:0] random_number,     /*This is random number from @speedController module*/
    output reg[2:0] result          /*This is result state*/
    );
    
    reg[2:0] result_state;
    
    always @(posedge clk_system or posedge rst) begin
        if(rst) begin
            /*Init state*/
            result_state <= `RESULT_NORMAL;
            result <= `RESULT_NORMAL;
        end
        else begin
            if(clk_system) begin
           
            if(play_again == `BUTTON_STATE_PRESSED) begin
                result_state <= `RESULT_NORMAL;
            end
            else if((game_mode == `GAME_MODE_0) || (game_mode == `GAME_MODE_1) || (game_mode == `GAME_MODE_2) || (game_mode == `GAME_MODE_3)) begin
                if(game_straight == `GAME_NO_STRAIGHT) begin
                   if((random_number[3:0] == random_number[7:4]) && (random_number[7:4] == random_number[11:8])) begin
                        result_state <= `RESULT_WIN;
                   end
                   else begin
                        result_state <= `RESULT_LOSE;
                   end 
                end
                else begin
                    /*game_straight == `GAME_STRAIGHT*/
                    if(type_of_straight == `GAME_STRAIGHT_INC) begin
                        if(((random_number[3:0] == random_number[7:4]) && (random_number[7:4] == random_number[11:8]))
                        || ((random_number[7:4] == random_number[3:0] + 1) && (random_number[11:8] == random_number[7:4] + 1))) begin
                            result_state <= `RESULT_WIN;
                        end
                        else begin
                            result_state <= `RESULT_LOSE;
                        end 
                    end
                    else begin
                        /*type_of_straight == `GAME_STRAIGHT_DEC*/
                        if(((random_number[3:0] == random_number[7:4]) && (random_number[7:4] == random_number[11:8]))
                        || ((random_number[7:4] == random_number[11:8] + 1) && (random_number[3:0] == random_number[7:4] + 1))) begin
                            result_state <= `RESULT_WIN;
                        end
                        else begin
                            result_state <= `RESULT_LOSE;
                        end 
                    end
                end
            end
            else begin
                /*game_mode == `GAME_MODE_SPECIAL*/
                if(random_number[3:0] == random_number[7:4]) begin
                    result_state <= `RESULT_SPECIAL_WIN;
                end
                else begin
                    result_state <= `RESULT_LOSE;
                end
            end
            /*Sync result value*/
            result <= result_state;
            
            end /*This is end of clk_system*/
        end
    end
endmodule
