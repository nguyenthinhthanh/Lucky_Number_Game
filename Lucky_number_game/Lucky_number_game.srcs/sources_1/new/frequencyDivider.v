`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 09:58:52 AM
// Design Name: 
// Module Name: frequencyDivider
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

/*This module for use to controll speed generateRandomNumber*/
module frequencyDivider #(
    parameter TARGET_CLK_FREQ = 1,           // Disired frequency
    parameter INPUT_CLK_FREQ = 125000000    // Input clock from Arty-z7
    )
    (
    input clk,
    input rst,
    output reg clk_out
    );
    
    // Calculate the number of clock cycles needed to achieve the target frequency
    localparam integer DIVISOR_TOGGLE = INPUT_CLK_FREQ / (2*TARGET_CLK_FREQ);
    
    reg [31:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            if(counter == (DIVISOR_TOGGLE-1)) begin
                clk_out <= ~clk_out;
                counter = 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
