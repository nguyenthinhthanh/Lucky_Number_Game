`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 10:38:17 AM
// Design Name: 
// Module Name: fsmForResultChecker
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


module fsmForResultChecker(
    input clk,                      /*This is clock on Arty-z7*/
    input rst,                      /*This is reset signal*/
    input game_straight,            /*This is game play have straight to win or not*/
    input type_of_straight,         /*This is straight increase or decrease*/
    input[2:0] game_mode,           /*This is game mode from @fsmForLuckyNumberGame module*/
    input [3:0] random_number0,     /*This is random number 0 from @generateRandomNumber module*/
    input [3:0] random_number1,     /*This is random number 1 from @generateRandomNumber module*/
    input [3:0] random_number2,     /*This is random number 2 from @generateRandomNumber module*/
    input [3:0] random_number3,     /*This is random number 3 from @generateRandomNumber module*/
    output reg[2:0] result_state    /*This is result state*/
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            /*Init state*/
            result_state <= `RESULT_NORMAL_STATE;
        end
        else begin
            if(game_mode == `GAME_MODE_0) begin
                case(result_state)
                    `RESULT_NORMAL_STATE: begin
                        if(game_straight == `GAME_NO_STRAIGHT) begin
                           if((random_number0 == random_number1) && (random_number1 == random_number2)) begin
                                result_state <= `RESULT_WIN_STATE;
                           end
                           else begin
                                result_state <= `RESULT_LOSE_STATE;
                           end 
                        end
                        else begin
                            /*game_straight == `GAME_STRAIGHT*/
                            if(type_of_straight == `GAME_STRAIGHT_INC) begin
                                if(((random_number0 == random_number1) && (random_number1 == random_number2))
                                || ((random_number1 == random_number0 + 1) && (random_number2 == random_number1 + 1))) begin
                                    result_state <= `RESULT_WIN_STATE;
                                end
                                else begin
                                    result_state <= `RESULT_LOSE_STATE;
                                end 
                            end
                            else begin
                                /*type_of_straight == `GAME_STRAIGHT_DEC*/
                                if(((random_number0 == random_number1) && (random_number1 == random_number2))
                                || ((random_number1 == random_number2 + 1) && (random_number0 == random_number1 + 1))) begin
                                    result_state <= `RESULT_WIN_STATE;
                                end
                                else begin
                                    result_state <= `RESULT_LOSE_STATE;
                                end 
                            end
                        end
                    end
                    `RESULT_LOSE_STATE: begin
                    
                    end
                    `RESULT_WIN_STATE: begin
                        if(random_number0 == random_number1) begin
                            result_state <= `RESULT_SPECIAL_WIN_STATE;
                        end
                        else begin
                            result_state <= `RESULT_LOSE_STATE;
                        end
                    end
                    `RESULT_SPECIAL_WIN_STATE: begin
                        
                    end
                endcase
            end
            else if(game_mode == `GAME_MODE_1) begin
            
            end
            else if(game_mode == `GAME_MODE_2) begin
            
            end
            else if(game_mode == `GAME_MODE_3) begin
                
            end
            else begin
                /*game_mode == `GAME_MODE_SPECIAL*/
            end
        end
    end
endmodule
