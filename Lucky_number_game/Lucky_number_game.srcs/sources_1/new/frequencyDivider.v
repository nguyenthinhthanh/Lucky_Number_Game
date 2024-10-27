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

/*This module for use to divide clk Arty-z7 to clk we want*/
module frequencyDivider #(
    parameter TARGET_CLK_FREQ = 400,            /*Disired frequency*/
    parameter INPUT_CLK_FREQ = 125000000        /*Input clock from Arty-z7*/
    )
    (
    input clk,                                  /*This is clk from Arty-z7*/
    input rst,                                  /*This is reset signal*/
    output reg clk_out                          /*This is clk out we want*/
    );
    
    // Calculate the number of clock cycles needed to achieve the target frequency
    localparam integer DIVISOR_TOGGLE = INPUT_CLK_FREQ / (2*TARGET_CLK_FREQ);
    
    reg[31:0] counter;                          /*This is counter for divider*/
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            if(clk) begin
                if(counter == (DIVISOR_TOGGLE-1)) begin
                    clk_out <= ~clk_out;
                    counter = 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
