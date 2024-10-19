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
    input clk,
    input D,
    output reg Q
    );
    
    always @(posedge clk) begin
        Q <= D;
    end
endmodule
