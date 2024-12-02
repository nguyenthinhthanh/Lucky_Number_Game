`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 10:09:23 AM
// Design Name: 
// Module Name: my_dff
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

/*This module foe D-Flip Flop*/
module my_dff(
    input clk,              /*This clk 400Hz - 2.5ms for read button and system*/
    input D,                /*This D in D-flip flop*/
    output reg Q            /*This Q in D-flip flop*/
    );
    
    always @(posedge clk) begin
        Q <= D;
    end
endmodule
