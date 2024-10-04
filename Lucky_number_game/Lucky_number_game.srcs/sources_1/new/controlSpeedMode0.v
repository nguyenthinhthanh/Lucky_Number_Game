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


module controlSpeedMode0(
    input clk,              // Clock from Arty-clk
    input rst,              // Reset signal
    input button,           // Button 0 signal
    input [1:0] game_mode,   // Game mode 0->4
    output reg getNumber    // Signal get random number
    );
    
    localparam FREQ_CLK = 32'd125000000;    // 125Mhz in Arty-z7
    localparam FAST_SPEED_FREQ = 3'd4;      // 4hz - 0.25s 
    localparam NORMAL_SPEED_FREQ = 3'd2;      // 2hz - 0.5s
    localparam LOW_SPEED_FREQ = 4'd1;      // 1hz - 1s
   
    localparam FAST_SPEED_COUNTER = FREQ_CLK / FAST_SPEED_FREQ; 
    localparam NORMAL_SPEED_COUNTER = FREQ_CLK / NORMAL_SPEED_FREQ;
    localparam LOW_SPEED_COUNTER = FREQ_CLK / LOW_SPEED_FREQ;
    
    reg [31:0] speed;
    reg [31:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            getNumber <= 0;
            speed <= FAST_SPEED_COUNTER;
            counter <= 0;
        end
        else begin
            // Reset signal get random number
            getNumber <= 0;
            case(game_mode)
            // Mode 0 : Press and release BTN0 
            2'b00: begin
                if(button) begin
                    // Get random number
                    getNumber <= 1;   
                end
                else begin
                    getNumber <= 0;
                end         
            end
            // Mode 1: Press and hold BTN0 speed constraint, release stop
            
            // Mode 2: Press and hold BTN0 speed increase then decrease    
            
            // Mode 3: Press and release BTN0, speed constraint then press
            // more to stop
            default: begin
                getNumber <= 0;
            end
            endcase
        end
    end
endmodule
