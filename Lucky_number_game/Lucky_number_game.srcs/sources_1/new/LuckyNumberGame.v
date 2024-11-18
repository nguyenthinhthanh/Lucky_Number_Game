`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 02:17:45 PM
// Design Name: 
// Module Name: LuckyNumberGame
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
/********************** This is top level module **********************/
/*Check https://github.com/nguyenthinhthanh/Lucky_Number_Game for FSM design and more detail*/
module LuckyNumberGame(
    input clk,                                  /*This is clk from Arty-z7*/
    input rst,                                  /*This is reset signal*/
    input[1:0] winner,                          /*This is two switch to control winner*/
    input[3:0] button,                          /*This is button read from Arty-z7*/
    output[3:0] led,                            /*This is output led*/
    output[5:0] rgb,
    output[15:0] bcd                            /*This is output bcd 16 bit Io26 to Io41*/
    //output check0,                              /*Just for debug*/
    //output check1,                              /*Just for debug*/
    //output check2                               /*Just for debug*/
    );
    
    wire clk_system;                            /*This clk 400Hz - 2.5ms for read button and system*/  
    
    wire[7:0] button_state_wire;                /*This is button state wire for connect between modules*/
    wire button_pressed_hold_wire;              /*Just for debug*/
    
    wire game_straight_wire;                    /*This is game straight wire for connect between modules*/
    wire type_of_straight_wire;                 /*This is type of straight wire for connect between modules*/
    wire control_mode_wire;                     /*This is control mode wire for connect between modules*/
    wire[2:0] game_mode_wire;                   /*This is game mode wire for connect between modules*/
    wire[15:0] fsm_state_wire;                  /*This is fsm state wire for connect between modules*/
    
    wire[2:0] result_state_wire;                /*This is result state wire for connect between modules*/
    
    wire[15:0] random_number_wire;              /*This is random number wire for connect betwwen modules*/
    
    wire done_mode_2_wire;                      /*This is done mode 2 wire for connect between modules*/
    
    assign bcd = random_number_wire;            /*This is bcd for 7seg output random number*/
    //assign bcd = fsm_state_wire;              /*Just for debug*/
    
    integer i;                                  /*This integer for travels between buttons*/
                  
    parameter TARGET_CLK_FREQ = 400;            /*This clk for every 400Hz - 2.5ms read button value */
    
    frequencyDivider #(                                 /*This is frequency divider*/ 
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)               //  @input : parameter TARGET_CLK_FREQ*/
    ) frequency_for_button_read_inst(                   //  @output : clk for systems
        .clk(clk),
        .rst(rst),
        .clk_out(clk_system)
    );
    
    fsmForButtonState fsm_for_button_state_inst(        /*This is fsm for button state*/
        .clk(clk),                                      //  @input : button_in[3:0] from Arty-z7
        .clk_system(clk_system),                        //  @output : button_state[7:0] @ref : BUTTON_STATE macro from header.vh
        .rst(rst),
        .button_in(button),
        .button_state(button_state_wire)
    );
    
    fsmForLuckyNumberGame fsm_for_lucky_number_game_inst(   /*This is fsm for whole system*/
        .clk_system(clk_system),                            //  @input : button_state[7:0] @from : fsmForButtonState module 
        .rst(rst),                                          //  @input : winner[1:0] switch from Arty-z7 just to demo 
        .winner(winner),                                    //  @input : result_state[2:0] @from : resultChecker module
        .result_state(result_state_wire),                   //  @input : done_mode_2 done mode 2 signal @from : speedController module
        .button_state(button_state_wire),                   //  @output : game configuration 
        .done_mode_2(done_mode_2_wire),                     //  @output : fsm_state[15:0] for whole system 
        .game_straight(game_straight_wire),
        .type_of_straight(type_of_straight_wire),
        .control_mode(control_mode_wire),
        .game_mode(game_mode_wire),
        .fsm_state(fsm_state_wire)
        //.check2(check2)
    );
    
    resultChecker result_checker(                  /*This is result checker for check result when done play*/
        .clk_system(clk_system),                   //  @input : fsm_state[15:0] @from: fsmForLuckyNumberGame module
        .rst(rst),                                 //  @input : game configuration @from: fsmForLuckyNumberGame module 
        .game_straight(game_straight_wire),        //  @input : random_number[15:0] @from: speedController module
        .type_of_straight(type_of_straight_wire),  //  @output : result_state[2:0] @ref : RESULT macro from header.vh
        .play_again(button_state_wire[5:4]),
        .game_mode(game_mode_wire),
        .random_number(random_number_wire),
        .fsm_state(fsm_state_wire),
        .result(result_state_wire)
    );
    
    speedController speed_controller_inst(          /*This is speed controller for each mode*/
        .clk(clk),                                  //  @input : fsm_state[15:0] @from: fsmForLuckyNumberGame module
        .rst(rst),                                  //  @input : game configuration @from: fsmForLuckyNumberGame module 
        .clk_system(clk_system),                    //  @output : random_numner[15:0]
        .game_mode(game_mode_wire),
        .fsm_state(fsm_state_wire),
        .done_mode_2(done_mode_2_wire),
        .random_number(random_number_wire)
        //.check0(check0),
        //.check1(check1)
    );
    
    /*toggleLedTop toggle_led_inst(                   *//*Just for debug*//*
        .clk_button(clk_system),
        .rst(rst),
        .led(led),
        .button_state(button_state_wire)
    );*/
    
    LED_Controller led_controller_inst(
        .clk(clk_system),
        .rst(rst),
        //.game_straight(game_straight_wire),
        //.type_of_straight(type_of_straight_wire),
        .control_mode(control_mode_wire),
        .game_mode(game_mode_wire),
        .fsm_state(fsm_state_wire),
        .rgb(rgb),
        .led(led)
    );
    
endmodule
