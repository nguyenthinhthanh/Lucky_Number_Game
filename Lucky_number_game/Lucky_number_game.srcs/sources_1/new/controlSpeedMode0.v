`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 04:38:52 PM
// Design Name: 
// Module Name: controlSpeedMode0
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

/*This module use to controll speed generate random number
for each mode*/
`include "header.vh"

module controlSpeedMode0(
    input clk,               /*This is clock on Arty-z7*/
    input rst,               /*This is reset signal*/
    input done_signal,       /*This is feedback signal when get random number done*/
    input[1:0] button_state0, /*This is BTN0 value*/
    input[2:0] game_mode,    /*This is game mode between 0 to 4*/
    output reg getNumber     /*This is signal for get random number*/
    );
    
    localparam FAST_SPEED_FREQ = 3'd4;           /*4hz - 0.25s */
    localparam NORMAL_SPEED_FREQ = 3'd2;         /*2hz - 0.5s*/
    localparam LOW_SPEED_FREQ = 4'd1;            /*1hz - 1s*/
   
    localparam FAST_SPEED_COUNTER = `CLK_FREQUENCY / FAST_SPEED_FREQ; 
    localparam NORMAL_SPEED_COUNTER = `CLK_FREQUENCY / NORMAL_SPEED_FREQ;
    localparam LOW_SPEED_COUNTER = `CLK_FREQUENCY / LOW_SPEED_FREQ;
    
    localparam TEST_SPEED_COUNTER = 10;
    
    reg [31:0] speed;       
    reg [31:0] counter;     /*This counter for speed controll*/
    
    always @(game_mode) begin
        /*Reset signal get random number when have mode change*/
        getNumber <= 0;
        counter <= 0;
        
        if(game_mode == `GAME_MODE_0) begin
            /*We will improve later now just get number immediately*/
            speed <= FAST_SPEED_COUNTER;
        end
        else if(game_mode == `GAME_MODE_1) begin
            speed <= NORMAL_SPEED_COUNTER;
        end
        else if(game_mode == `GAME_MODE_2) begin
            
        end
        else if(game_mode == `GAME_MODE_3) begin
        
        end
        else begin
            /*This is game_mode == `GAME_MODE_SPECIAL*/
            
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            getNumber <= 0;
            speed <= FAST_SPEED_COUNTER;
            counter <= 0;
        end
        else begin
            if(done_signal) begin
                getNumber <= 0;
            end
            else begin
               case(game_mode)
               /*Mode 0 : Press and release BTN0
                 we will improve later now just get number immediately*/
                `GAME_MODE_0: begin
                    if(button_state0 == `BUTTON_STATE_PRESSED) begin
                        /*Get random number*/
                        getNumber <= 1;   
                    end
                    else begin
                        /*Clear getNumber signal*/
                        getNumber <= 0;
                    end         
                end
                /*Mode 1: Press and hold BTN0 speed constraint, release stop
                  We will implement 0.25s will generate new random number */
                `GAME_MODE_1: begin
                    if(button_state0) begin
                        counter <= counter + 1;
                        if(counter >= speed || counter >= TEST_SPEED_COUNTER) begin
                            getNumber <= 1;
                            counter <= 0;
                        end
                    end
                    else begin
                        getNumber <= 0;
                    end
                end
                /*Mode 2: Press and hold BTN0 speed increase then decrease*/  
                `GAME_MODE_2: begin  
                                    
                end
                /*Mode 3: Press and release BTN0, speed constraint then press
                 more to stop*/
                `GAME_MODE_3: begin
                
                end
                /*Special mode will use mode 3 but just two number and 
                 speed will increase*/
                `GAME_MODE_SPECIAL: begin
                    
                end
                default: begin
                    getNumber <= 0;
                end
            endcase 
            end
        end
    end
endmodule
