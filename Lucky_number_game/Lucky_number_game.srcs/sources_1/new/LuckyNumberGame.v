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

/********************** This is top level module **********************/
/*Check https://github.com/nguyenthinhthanh/Lucky_Number_Game for FSM design and more detail*/
module LuckyNumberGame(
    input clk,                                  /*This is clk from Arty-z7*/
    input rst,                                  /*This is reset signal*/
    input[1:0] winner,                          /*This is two switch to control winner*/
    input[3:0] button,                          /*This is button read from Arty-z7*/
    output[3:0] led,                            /*This is output led*/
    output[15:0] bcd,                           /*This is output bcd 16 bit Io26 to Io41*/
    output check0,                              /*Just for debug*/
    output check1                               /*Just for debug*/
    );
    
    wire clk_system;                            /*This clk 400Hz - 2.5ms for read button and system*/  
    
    wire[7:0] button_state_wire;                /*This is button state wire for connect between modules*/
    wire button_pressed_hold_wire;              /*Just for debug*/
    
    wire game_straight_wire;                    /*This is game straight wire for connect between modules*/
    wire type_of_straight_wire;                 /*This is type of straight wire for connect between modules*/
    wire control_mode_wire;                     /*This is control mode wire for connect between modules*/
    wire[2:0] game_mode_wire;                   /*This is game mode wire for connect between modules*/
    wire[7:0] fsm_state_wire;                   /*This is fsm state wire for connect between modules*/
    
    wire[2:0] result_state_wire;                /*This is result state wire for connect between modules*/
    
    wire random_number_wire;
    assign bcd = random_number_wire;
    
    integer i;                                  /*This integer for travels between buttons*/
                  
    parameter TARGET_CLK_FREQ = 400;            /*This clk for every 400Hz - 2.5ms read button value */
    
    frequencyDivider #(                         /*This is frequency divider*/ 
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)       //  @input : parameter TARGET_CLK_FREQ*/
    ) frequency_for_button_read_inst(           //  @output : clk for systems
        .clk(clk),
        .rst(rst),
        .clk_out(clk_system)
    );
    
    fsmForButtonState fsm_for_button_state_inst(    /*This is fsm for button state*/
        .clk(clk),                                  //  @input : button_in[3:0] from Arty-z7
        .clk_system(clk_system),                    //  @output : button_state[7:0] @ref : BUTTON_STATE macro from header.vh
        .rst(rst),
        .button_in(button),
        .button_state(button_state_wire)
    );
    
    fsmForLuckyNumberGame fsm_for_lucky_number_game_inst(
        .clk_system(clk_system),
        .rst(rst),
        .winner(winner),
        .result_state(result_state_wire),
        .button_state(button_state_wire),
        .game_straight(game_straight_wire),
        .type_of_straight(type_of_straight_wire),
        .control_mode(control_mode_wire),
        .game_mode(game_mode_wire),
        .fsm_state(fsm_state_wire)
    );
    
    resultChecker result_checker(
        .clk_system(clk_system),
        .rst(rst),
        .game_straight(game_straight_wire),
        .type_of_straight(type_of_straight_wire),
        .play_again(button_state_wire[5:4]),
        .game_mode(game_mode_wire),
        .random_number(random_number_wire),
        .result(result_state_wire)
    );
    
    speedController speed_controller_inst(          /*This is speed controller for each mode*/
        .clk(clk),                                  //  @input : button_state[7:0] @ref: fsmForButtonState module
        .rst(rst),                                  //  @output : random_number[15:0] 
        .clk_system(clk_system),
        .game_mode(game_mode_wire),
        .fsm_state(fsm_state_wire),
        .random_number(random_number_wire),
        .check0(check0),
        .check1(check1)
    );
    
    toggleLedTop toggle_led_inst(                   /*Just for debug*/
        .clk_button(clk_system),
        .rst(rst),
        .led(led),
        .button_state(button_state_wire)
    );
    
endmodule
