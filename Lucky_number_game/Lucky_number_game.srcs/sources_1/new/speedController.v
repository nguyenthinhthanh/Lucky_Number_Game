`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 09:20:41 AM
// Design Name: 
// Module Name: speedController
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

/*This module for control speed generate random number for each mode*/
module speedController(
    input clk,                          /*This is clk from Arty-z7*/
    input rst,                          /*This is reset signal*/
    input clk_system,                   /*This clk 400Hz - 2.5ms for read button and system*/
    input[2:0] game_mode,               /*This is configure of game mode @from : fsmForLuckyNumberGame module*/
    input[15:0] fsm_state,              /*This is fsm state @from : fsmForLuckyNumberGame module*/
    //input[7:0] button_state,          /*This is button state @from : fsmForButtonState module*/
    output reg done_mode_2,             /*This signal will set when we done in mode 2*/   
    output reg[15:0] random_number,     /*This is random number output*/ 
    output reg check0,                  /*Just for debug*/
    output reg check1                   /*Just for debug*/
    );
    
    wire clk_random_number;             /*This clk for generate random number*/
    wire[15:0] random_number_wire;      /*This is random number wire for connect between modules*/
    
    integer i;                          /*This integer for travels between buttons*/
    
    parameter TARGET_CLK_FREQ_NORMAL = `CLK_FREQ_NORMAL_SPEED;      /*For every 40ms generate random number*/
    
    localparam MIN_SPEED_COUNTER = `MIN_SPEED_COUNTER;              /*For counter speed in mode 3*/
    localparam MAX_SPEED_COUNTER = `MAX_SPEED_COUNTER;              /*For counter speed in mode 3*/
     
    reg[7:0] counter_speed[3:0];                                    /*This is counter for speed*/
    reg[7:0] speed[3:0];                                            /*This is speed we will increase and decrease*/
    
    reg done_mode_0;
    
    reg[1:0] seed[3:0];                                     /*This is seed for generate random number*/
    
    frequencyDivider #(                                     /*This is frequency divider*/
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ_NORMAL)            //  @input : parameter TARGET_CLK_FREQ*/
    ) frequency_for_button_read_inst(                       //  @output : clk for generate random number
        .clk(clk),
        .rst(rst),
        .clk_out(clk_random_number)
    );
    
    generateRandomNumber generate_random_number0_inst(      /*This is module for generate random number*/
        .clk(clk_random_number),                            /*using Linear Feedback Shift Register (LFSR)*/
        .rst(rst),                                          // @input : clk random number @ref : frequencyDivider
        .seed(seed[0]),
        .random_number(random_number_wire[3:0])             // @output : random number from 0 to 9
    );
    
    generateRandomNumber generate_random_number1_inst(      /*This is module for generate random number*/
        .clk(clk_random_number),                            /*using Linear Feedback Shift Register (LFSR)*/
        .rst(rst),                                          // @input : clk random number @ref : frequencyDivider
        .seed(seed[1]),
        .random_number(random_number_wire[7:4])             // @output : random number from 0 to 9
    );
    
    generateRandomNumber generate_random_number2_inst(      /*This is module for generate random number*/
        .clk(clk_random_number),                            /*using Linear Feedback Shift Register (LFSR)*/
        .rst(rst),                                          // @input : clk random number @ref : frequencyDivider
        .seed(seed[2]),
        .random_number(random_number_wire[11:8])            // @output : random number from 0 to 9
    );
    
    generateRandomNumber generate_random_number3_inst(      /*This is module for generate random number*/
        .clk(clk_random_number),                            /*using Linear Feedback Shift Register (LFSR)*/
        .rst(rst),                                          // @input : clk random number @ref : frequencyDivider
        .seed(seed[3]),
        .random_number(random_number_wire[15:12])           // @output : random number from 0 to 9
    );
    
    
    always @(posedge clk_system or posedge rst) begin
        if(rst) begin
            random_number <= 16'b0000_0000_0000;            /*Reset random_number default*/
            
            check0 <= 0;                                    /*Just for debug*/
            check1 <= 0;                                    /*Just for debug*/
            
            done_mode_0 <= 0;                               /*This signal will set when we done mode 0*/
            done_mode_2 <= 0;                               /*This signal will set when we done mode 2*/
            
            for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                seed[i] = i;                                /*This is seed for diff random number*/
            
                counter_speed[i] <= 8'b0000_0000;           /*This is counter speed for mode 2*/
                speed[i] <= MIN_SPEED_COUNTER;              /*This is min speed default for mode 2*/
            end
        end
        else begin
            if(clk_system) begin
                /*Display game mode in 7seg 3th*/
                random_number[15:12] <= game_mode;
                
                if(fsm_state == `FSM_STATE_SET_MODE_0) begin
                    /*Reset done signal in mode 0 and 2*/
                    done_mode_0 <= 0;
                    done_mode_2 <= 0;
                
                    random_number <= 16'b0000_0000_0000;
                end
                else if(fsm_state == `FSM_STATE_NO_33) begin
                   /*Play mode 3*/
                   for(i=0;i<`NUM_OF_7SEG_MODE_3;i=i+1) begin
                        /*7seg will spin ramdom number continuos*/
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                   end
                end
                else if(fsm_state == `FSM_STATE_NO_34) begin
                    if(game_mode == `GAME_MODE_0) begin
                        /*if(!done_mode_0) begin
                            for(i=0;i<`NUM_OF_7SEG_MODE_0;i=i+1) begin
                                random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                            end
                            *//*Spin 1 time
                            ************May be not use done_mode_0*************//*
                            done_mode_0 <= 1;
                        end*/
                        
                        for(i=0;i<`NUM_OF_7SEG_MODE_0;i=i+1) begin
                            random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                        end
                    end
                    /*else if(game_mode == `GAME_MODE_1) begin
                        *//*Stop spin random number and check result*//*
                        //random_number <= random_number;
                    end*/
                    else if(game_mode == `GAME_MODE_2) begin
                        /*When button realeased speed decrease*/
                        for(i=0;i<3;i=i+1) begin
                            counter_speed[i] <= counter_speed[i] + 1;
                            if (counter_speed[i] >= speed[i]) begin
                                counter_speed[i] <= 0;
                                if(speed[i] < MIN_SPEED_COUNTER) begin
                                    speed[i] <= speed[i] + 4;
                       
                                    check0 <= ~check0;      /*Just for debug*/
                                    /*Update random number depend of speed*/
                                    random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                                end
                                else begin
                                    done_mode_2 <= 1;
                                end
                            end
                        end
                    end
                    /*else if(game_mode == `GAME_MODE_3) begin
                        *//*Stop spin random number and check result*//*
                        //random_number <= random_number;
                    end*/
                    else begin
                        random_number <= random_number;
                    end
                end
                else if(fsm_state == `FSM_STATE_NO_42) begin
                    for(i=0;i<`NUM_OF_7SEG_MODE_1;i=i+1) begin
                        /*7seg will spin ramdom number continuos*/
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                    end
                end
                else if(fsm_state == `FSM_STATE_NO_43) begin
                    for(i=0;i<3;i=i+1) begin
                        counter_speed[i] <= counter_speed[i] + 1;
                        if (counter_speed[i] >= speed[i]) begin
                            counter_speed[i] <= 0;
                            if(speed[i] > MAX_SPEED_COUNTER) begin
                                speed[i] <= speed[i] - 4;
                                
                                check1 <= ~check1;      /*Just for debug*/
                            end
                            
                            /*Update random number depend of speed*/
                            random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                        end
                    end
                end
                else begin
                    /*Reset done signal in mode 0 and 2*/
                    done_mode_0 <= 0;
                    done_mode_2 <= 0;
                    //random_number <= random_number;
                end
            
                /*for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                    if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED) begin
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                    end
                    *//*else if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD) begin
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                    end*//*
                    else if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD) begin
                        counter_speed[i] <= counter_speed[i] + 1;
                        if (counter_speed[i] >= speed[i]) begin
                            counter_speed[i] <= 0;
                            if(speed[i] > MAX_SPEED_COUNTER) begin
                                speed[i] <= speed[i] - 4;
                                
                                check1 <= ~check1;      *//*Just for debug*//*
                            end
                            
                            *//*Update random number depend of speed*//*
                            random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                        end
                    end
                    else if(button_state[i*2 +:2] == `BUTTON_STATE_RELEASED) begin
                        counter_speed[i] <= counter_speed[i] + 1;
                        if (counter_speed[i] >= speed[i]) begin
                            counter_speed[i] <= 0;
                            if(speed[i] < MIN_SPEED_COUNTER) begin
                                speed[i] <= speed[i] + 4;
                   
                                check0 <= ~check0;      *//*Just for debug*//*
                                *//*Update random number depend of speed*//*
                                random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                            end
                        end
                    end
                end*/
            end
        end
    end
    
endmodule
