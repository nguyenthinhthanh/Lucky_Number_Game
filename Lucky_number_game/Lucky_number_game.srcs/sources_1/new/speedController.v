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
    input clk,
    input rst,
    input clk_button,
    /*input control_mode,
    input[2:0] game_mode,
    input[7:0] fsm_state,*/
    input[7:0] button_state,             /*This is button state from @fsmForButtonState module*/
    output reg[15:0] random_number
    );
    
    wire clk_random_number;
    wire[15:0] random_number_wire;
    
    integer i;
    
    parameter TARGET_CLK_FREQ_NORMAL = `CLK_FREQ_NORMAL_SPEED;      /*For every 40ms generate random number*/
    
    localparam MIN_SPEED_COUNTER = `MIN_SPEED_COUNTER;
    localparam MAX_SPEED_COUNTER = `MAX_SPEED_COUNTER;
     
    reg[7:0] counter_speed[3:0];
    reg[7:0] speed[3:0];
    
    frequencyDivider #(
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ_NORMAL)
    ) frequency_for_button_read_inst(
        .clk(clk),
        .rst(rst),
        .clk_out(clk_random_number)
    );
    
    generateRandomNumber generate_random_number0_inst(
        .clk(clk_random_number),
        .rst(rst),
        .random_number(random_number_wire[3:0])
    );
    
    generateRandomNumber generate_random_number1_inst(
        .clk(clk_random_number),
        .rst(rst),
        .random_number(random_number_wire[7:4])
    );
    
    generateRandomNumber generate_random_number2_inst(
        .clk(clk_random_number),
        .rst(rst),
        .random_number(random_number_wire[11:8])
    );
    
    generateRandomNumber generate_random_number3_inst(
        .clk(clk_random_number),
        .rst(rst),
        .random_number(random_number_wire[15:12])
    );
    
    
    always @(posedge clk_button or posedge rst) begin
        if(rst) begin
            random_number <= 16'b0000_0000_0000;
            
            for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                counter_speed[i] <= 8'b0000_0000;
                speed[i] <= MIN_SPEED_COUNTER;
            end
        end
        else begin
            if(clk_button) begin
                for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                    if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED) begin
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                    end
                    /*else if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD) begin
                        random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                    end*/
                    else if(button_state[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD) begin
                        counter_speed[i] <= counter_speed[i] + 1;
                        if (counter_speed[i] >= speed[i]) begin
                            counter_speed[i] <= 0;
                            if(speed[i] > MAX_SPEED_COUNTER) begin
                                speed[i] <= speed[i] - 4;
                                
                                /*Update random number depend of speed*/
                                random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                            end
                        end
                    end
                    else if(button_state[i*2 +:2] == `BUTTON_STATE_RELEASED) begin
                        counter_speed[i] <= counter_speed[i] + 1;
                        if (counter_speed[i] >= speed[i]) begin
                            counter_speed[i] <= 0;
                            if(speed[i] < MIN_SPEED_COUNTER) begin
                                speed[i] <= speed[i] + 4;
                                
                                /*Update random number depend of speed*/
                                random_number[i*4 +:4] <= random_number_wire[i*4 +:4];
                            end
                        end
                    end
                end
            end
        end
    end
    
endmodule
