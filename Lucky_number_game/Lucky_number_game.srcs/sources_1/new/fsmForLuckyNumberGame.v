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

`include "header.vh"

/*This module is fsm for all state in whole system
    another module just read state or output configuration from here
    to do action corresponding to the state
    */
module fsmForLuckyNumberGame(
    input clk_system,                       /*This clk 400Hz - 2.5ms for system*/
    input rst,                              /*This is reset signal*/
    input done_mode_2,                      /*This signal when done mode 2 @from : speedController*/
    input[1:0] winner,                      /*This is two switch to control winner, just for demo*/
    input[2:0] result_state,                /* This is result state @from : resultChecker module*/
    input[7:0] button_state,                /*This is button state @from : fsmForButtonState module*/
    output reg game_straight,               /*This is configure of game straight*/
    output reg type_of_straight,            /*This is configure type of game straight*/
    output reg control_mode,                /*This is configure of setting mode or playing mode*/
    output reg[2:0] game_mode,              /*This is configure of game mode between 0 to 3*/
    output reg[15:0] fsm_state             /*This is output fsm state for all module to read and do something in this state*/
    //output reg check2                       /*Just for debug*/
    );
    
    reg game_straight_reg;                  /*This just reg for store game_straight value*/
    reg type_of_straight_reg;               /*This just reg for store type_of_straight value*/
    reg control_mode_reg;                   /*This just reg for store controol_mode value*/
    reg[2:0] game_mode_reg;                 /*This just reg for store game_mode value*/
    reg[15:0] fsm_state_reg;                 /*This just reg for store fsm_state value*/
    
    /*Setting_mode                          Play_mode          
    BTN0 : To change mode                   BTN0 : To play
    BTN1 : To next setting                  BTN1 : To "Yes"
    BTN2 : To back setting previous         BTN2 : To "No"
    BTN3 : To reset setiing                 BTN3 : To play again
    */
    always @(posedge clk_system or posedge rst) begin
        if(rst) begin
            game_straight <= `GAME_NO_STRAIGHT;             /*Default game is no have straight*/
            type_of_straight <= `GAME_STRAIGHT_INC;         /*Just don't care because game no straight default*/
            control_mode <= `GAME_CONTROL_SETTING_MODE;     /*Default control mode is setting mode*/ 
            game_mode <= `GAME_MODE_0;                      /*Default mode is 0*/
            
            game_straight_reg <= `GAME_NO_STRAIGHT;             /*Default game is no have straight*/
            type_of_straight_reg <= `GAME_STRAIGHT_INC;         /*Just don't care because game no straight default*/
            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     /*Default control mode is setting mode*/ 
            game_mode_reg <= `GAME_MODE_0;                      /*Default mode is 0*/
            
            fsm_state <= `FSM_STATE_SET_MODE_0;             /*This is init state*/
            fsm_state_reg <= `FSM_STATE_SET_MODE_0;         /*This is init state reg*/
            
            //check2 <= 0;                                    /*Just for debug*/
        end
        else begin
            if(clk_system) begin
                /********************May be we use another switch in extend board Arty-z7********************/
                if(button_state[7:6] == `BUTTON_STATE_PRESSED_HOLD) begin
                    /*BTN3 pressed and hold to come back init state 0
                        we need to reset all configure before*/
                    game_straight <= `GAME_NO_STRAIGHT;             
                    type_of_straight <= `GAME_STRAIGHT_INC;         
                    control_mode <= `GAME_CONTROL_SETTING_MODE;     
                    game_mode <= `GAME_MODE_0;
                    
                    game_straight_reg <= `GAME_NO_STRAIGHT;             
                    type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                    control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                    game_mode_reg <= `GAME_MODE_0;                      
                    
                    fsm_state <= `FSM_STATE_SET_MODE_0;            
                    fsm_state_reg <= `FSM_STATE_SET_MODE_0;         
                end
                else if(winner[0] && !winner[1]) begin
                    /*If sw0 == 1 && sw1 == 0, win normal game*/
                    fsm_state_reg <= `FSM_STATE_NO_40;
                end
                else if(winner[0] && winner[1]) begin
                    /*If sw0 == 1 && sw1 == 1, win special game*/
                    fsm_state_reg <= `FSM_STATE_NO_39;
                end
                else begin
                case(fsm_state_reg)
                    /********************Begin state setting game mode********************/
                    `FSM_STATE_SET_MODE_0: begin    /*State 0*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_1; 
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_1;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                    end
                    `FSM_STATE_SET_MODE_1: begin    /*State 1*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_2;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_2;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_1;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_MODE_1;
                        end
                    end
                    `FSM_STATE_SET_MODE_2: begin    /*State 2*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_3;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_3;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_2;
                              
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_MODE_2;
                        end
                    end
                    `FSM_STATE_SET_MODE_3: begin    /*State 3*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game mode*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game mode and 
                              next setting straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_3;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_MODE_3;
                        end
                    end
                    /********************Done state setting game mode********************/
                    
                    /********************Begin state setting game straight********************/
                    `FSM_STATE_SET_NO_STRAIGHT: begin    /*State 5,12,19,26*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_1;
                            
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game straight and 
                              next finish setting mode*/
                           
                           /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_PLAY_MODE;     
                            //game_mode <= `GAME_MODE_1;
                           
                            fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 pressed to back previous step*/
                            if(game_mode_reg == `GAME_MODE_0) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_0;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                            end
                            else if(game_mode_reg == `GAME_MODE_1) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_1;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_1;
                            end
                            else if(game_mode_reg == `GAME_MODE_2) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_2;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_2;
                            end
                            else begin
                                /*game_mode == `GAME_MODE_3*/
                                
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_3;
                                
                                fsm_state_reg <= `FSM_STATE_SET_MODE_3;
                            end
                        end
                        else if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                            /*BTN3 pressed to reset all setting before*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                    end
                    `FSM_STATE_SET_STRAIGHT: begin    /*State 6,13,20,27*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change game straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_1;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set game straight and 
                              next finish setting mode*/
                              
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_1;  
                              
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT_INC;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 pressed to back previous step*/
                            if(game_mode_reg == `GAME_MODE_0) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_0;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                            end
                            else if(game_mode_reg == `GAME_MODE_1) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_1;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_1;
                            end
                            else if(game_mode_reg == `GAME_MODE_2) begin
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_2;
                            
                                fsm_state_reg <= `FSM_STATE_SET_MODE_2;
                            end
                            else begin
                                /*game_mode == `GAME_MODE_3*/
                                
                                /*Set enviroment for next step*/
                                game_straight_reg <= `GAME_NO_STRAIGHT;             
                                type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                                control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                                game_mode_reg <= `GAME_MODE_3;
                                
                                fsm_state_reg <= `FSM_STATE_SET_MODE_3;
                            end
                        end
                        else if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                            /*BTN3 pressed to reset all setting before*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT;
                        end
                    end
                    /********************Done state setting game straight********************/
                    
                    /********************Begin state seting type of straight********************/
                    `FSM_STATE_SET_STRAIGHT_INC: begin    /*State 7,14,21,28*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change type of straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_DEC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT_DEC;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 pressed to set type of straight and 
                              next finish setting mode*/
                              
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_PLAY_MODE;     
                            //game_mode <= `GAME_MODE_0;  
                              
                            fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 pressed to back previous step*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                            /*BTN3 pressed to reset all setting before*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT_INC;
                        end
                    end
                    `FSM_STATE_SET_STRAIGHT_DEC: begin    /*State 8,15,22,29*/
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to change type of straight*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT_INC;
                        end
                        else if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            //check2 <= 1;
                            /*BTN1 pressed to set type of straight and 
                              next finish setting mode*/
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_DEC;         
                            control_mode_reg <= `GAME_CONTROL_PLAY_MODE;     
                            //game_mode <= `GAME_MODE_0;  
                              
                            fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 pressed to back previous step*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            //game_mode <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_NO_STRAIGHT;
                        end
                        else if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                            /*BTN3 pressed to reset all setting before*/
                            
                            /*Set enviroment for next step*/
                            game_straight_reg <= `GAME_NO_STRAIGHT;             
                            type_of_straight_reg <= `GAME_STRAIGHT_INC;         
                            control_mode_reg <= `GAME_CONTROL_SETTING_MODE;     
                            game_mode_reg <= `GAME_MODE_0;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_0;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_STRAIGHT_DEC;
                        end
                    end
                    /********************Done state setting type of straight********************/
                    
                    /********************DONE SETTING, NOW WE PLAY :)********************/
                    /********************Begin state playing game********************/
                    /*Fsm state share for 9,16,23,30 state*/
                    /*Fsm state share for 10,17,24,31 state*/
                    /*Fsm state share for 11,18,25,32 state*/
                    `FSM_STATE_NO_STRAIGHT_PLAY: begin
                        //check2 <= 1;
                        
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to play game*/
                            
                            if(game_mode_reg == `GAME_MODE_0) begin
                                fsm_state_reg <= `FSM_STATE_NO_34;
                                //check2 <= 1;
                            end
                            else if(game_mode_reg == `GAME_MODE_3) begin
                                fsm_state_reg <= `FSM_STATE_NO_33;
                            end
                            else begin
                                /*Mode 1,2 need to pressed and hold*/
                                fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                                //check2 <= 1;
                            end
                        end
                        else if(button_state[1:0] == `BUTTON_STATE_PRESSED_HOLD) begin
                            /*BTN0 pressed and hold to play game*/
                            if(game_mode_reg == `GAME_MODE_1) begin
                                fsm_state_reg <= `FSM_STATE_NO_42;
                            end
                            else if(game_mode_reg == `GAME_MODE_2) begin
                                fsm_state_reg <= `FSM_STATE_NO_43;
                            end
                            else begin
                                /*No change state*/
                                fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                            end
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                        end
                    end
                    `FSM_STATE_STRAIGHT_INC_PLAY: begin
                        //check2 <= 1;
                        
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to play game*/
                            
                            if(game_mode_reg == `GAME_MODE_0) begin
                                fsm_state_reg <= `FSM_STATE_NO_34;
                                //check2 <= 1;
                            end
                            else if(game_mode_reg == `GAME_MODE_3) begin
                                fsm_state_reg <= `FSM_STATE_NO_33;
                            end
                            else begin
                                /*Mode 1,2 need to pressed and hold*/
                                fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                                //check2 <= 1;
                            end
                        end
                        else if(button_state[1:0] == `BUTTON_STATE_PRESSED_HOLD) begin
                            /*BTN0 pressed and hold to play game*/
                            if(game_mode_reg == `GAME_MODE_1) begin
                                fsm_state_reg <= `FSM_STATE_NO_42;
                            end
                            else if(game_mode_reg == `GAME_MODE_2) begin
                                fsm_state_reg <= `FSM_STATE_NO_43;
                            end
                            else begin
                                /*No change state*/
                                fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                            end
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                        end
                    end
                    `FSM_STATE_STRAIGHT_DEC_PLAY: begin
                        //check2 <= 1;
                        
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to play game*/
                            
                            if(game_mode_reg == `GAME_MODE_0) begin
                                fsm_state_reg <= `FSM_STATE_NO_34;
                                //check2 <= 1;
                            end
                            else if(game_mode_reg == `GAME_MODE_3) begin
                                fsm_state_reg <= `FSM_STATE_NO_33;
                            end
                            else begin
                                /*Mode 1,2 need to pressed and hold*/
                                fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                                //check2 <= 1;
                            end
                        end
                        else if(button_state[1:0] == `BUTTON_STATE_PRESSED_HOLD) begin
                            /*BTN0 pressed and hold to play game*/
                            if(game_mode_reg == `GAME_MODE_1) begin
                                fsm_state_reg <= `FSM_STATE_NO_42;
                            end
                            else if(game_mode_reg == `GAME_MODE_2) begin
                                fsm_state_reg <= `FSM_STATE_NO_43;
                            end
                            else begin
                                /*No change state*/
                                fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                            end
                        end
                        else begin
                            /*No change state*/
                            //check2 <= 1;
                            fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                        end
                    end
                    `FSM_STATE_NO_33: begin     /*State 33*/    
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN0 pressed to play game*/
                            fsm_state_reg <= `FSM_STATE_NO_34;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_33;
                        end
                    end
                    
                    `FSM_STATE_NO_34: begin     /*State 34*/    
                        /*This is a buffer state just for make sure
                            game is ready for result checkker*/
                        if(game_mode_reg == `GAME_MODE_2) begin
                            //check2 <= 1;
                            if(done_mode_2) begin
                                fsm_state_reg <= `FSM_STATE_FINAL_RESULT;    
                            end
                            else begin
                                fsm_state_reg <= `FSM_STATE_NO_34;
                            end
                        end    
                        else begin
                            fsm_state_reg <= `FSM_STATE_FINAL_RESULT;
                        end
                    end
                    
                    `FSM_STATE_NO_42: begin    /*State 42*/  
                        if(button_state[1:0] == `BUTTON_STATE_RELEASED) begin
                            fsm_state_reg <= `FSM_STATE_NO_34;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_42;
                        end
                    end
                    `FSM_STATE_NO_43: begin    /*State 43*/  
                        if(button_state[1:0] == `BUTTON_STATE_RELEASED) begin
                            fsm_state_reg <= `FSM_STATE_NO_34;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_43;
                        end
                    end
                    `FSM_STATE_FINAL_RESULT: begin    /*State 41*/  
                        if(result_state == `RESULT_LOSE) begin
                            /*When player lose the game*/
                            fsm_state_reg <= `FSM_STATE_NO_35;
                        end
                        else if(result_state == `RESULT_WIN) begin
                            /*When player win the game*/
                            //check2 <= 1;
                            fsm_state_reg <= `FSM_STATE_NO_36;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_FINAL_RESULT;
                        end
                    end
                    `FSM_STATE_NO_35: begin    /*State 35*/  
                        if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                             /*BTN3 pressed to play again*/
                            if(game_straight_reg == `GAME_NO_STRAIGHT) begin
                                fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                            end
                            else begin
                                /*If game play have straight*/
                                if(type_of_straight_reg == `GAME_STRAIGHT_INC) begin
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                                end
                                else begin
                                    /*type_of_straight == `GAME_STRAIGHT_DEC*/
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                                end
                            end
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_35;
                        end  
                    end
                    `FSM_STATE_NO_36: begin    /*State 36*/  
                        if(button_state[3:2] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 press to "Yes", play special mode*/
                            
                            /*Set enviroment for next step*/
                            game_mode_reg <= `GAME_MODE_SPECIAL;
                            
                            fsm_state_reg <= `FSM_STATE_SET_MODE_SPECIAL;
                        end
                        else if(button_state[5:4] == `BUTTON_STATE_PRESSED) begin
                            /*BTN2 press to "No", don't play special mode, received reward*/
                            fsm_state_reg <= `FSM_STATE_NO_40;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_36;
                        end
                    end
                    `FSM_STATE_NO_40: begin    /*State 40*/  
                        if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                             /*BTN3 pressed to play again*/
                            if(game_straight_reg == `GAME_NO_STRAIGHT) begin
                                fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                            end
                            else begin
                                /*If game play have straight*/
                                if(type_of_straight_reg == `GAME_STRAIGHT_INC) begin
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                                end
                                else begin
                                    /*type_of_straight == `GAME_STRAIGHT_DEC*/
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                                end
                            end
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_40;
                        end
                    end
                    /********************Done state playing game********************/
                    
                    /********************Begin state playing game special mode********************/
                    `FSM_STATE_SET_MODE_SPECIAL: begin    /*State 4*/  
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 press to play game special mode*/
                            fsm_state_reg <= `FSM_STATE_NO_37;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_SET_MODE_SPECIAL;
                        end
                    end
                    `FSM_STATE_NO_37: begin    /*State 37*/  
                        if(button_state[1:0] == `BUTTON_STATE_PRESSED) begin
                            /*BTN1 press to play game special mode*/
                            fsm_state_reg <= `FSM_STATE_NO_38;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_37;
                        end
                    end
                    `FSM_STATE_NO_38: begin    /*State 38*/  
                        if(result_state == `RESULT_LOSE) begin
                            /*When player lose the game*/
                            fsm_state_reg <= `FSM_STATE_NO_35;
                        end
                        else if(result_state == `RESULT_SPECIAL_WIN) begin
                            /*When player win the special game mode, received reward*/
                            fsm_state_reg <= `FSM_STATE_NO_39;
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_38;
                        end
                    end
                    `FSM_STATE_NO_39: begin    /*State 38*/  
                        if(button_state[7:6] == `BUTTON_STATE_PRESSED) begin
                             /*BTN3 pressed to play again*/
                            if(game_straight_reg == `GAME_NO_STRAIGHT) begin
                                fsm_state_reg <= `FSM_STATE_NO_STRAIGHT_PLAY;
                            end
                            else begin
                                /*If game play have straight*/
                                if(type_of_straight_reg == `GAME_STRAIGHT_INC) begin
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_INC_PLAY;
                                end
                                else begin
                                    /*type_of_straight == `GAME_STRAIGHT_DEC*/
                                    fsm_state_reg <= `FSM_STATE_STRAIGHT_DEC_PLAY;
                                end
                            end
                        end
                        else begin
                            /*No change state*/
                            fsm_state_reg <= `FSM_STATE_NO_39;
                        end
                    end
                    /********************Done state playing game special mode********************/
                endcase
                end /*This is end for come back init state 0*/
                
                /*Sync configure and fsm state vaule*/
                game_straight <= game_straight_reg;             
                type_of_straight <= type_of_straight_reg;         
                control_mode <= control_mode_reg;     
                game_mode <= game_mode_reg;  
                
                fsm_state <= fsm_state_reg;
            end
        end
    end
endmodule
