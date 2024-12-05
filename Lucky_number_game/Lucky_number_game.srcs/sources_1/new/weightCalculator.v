`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 12:27:30 PM
// Design Name: 
// Module Name: weightCalculator
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


module weightCalculator(
    input wire clk,
    input wire[63:0] history, // L?ch s? quay 16x 4 bit number 
    output reg[79:0] weights   // Tr?ng s? cho t?ng s? t? 0-9
);

    integer i, j;
    reg [3:0] count [0:9];

    always @(posedge clk) begin
        // ??m s? l?n xu?t hi?n
        for (i = 0; i < 10; i = i + 1) begin
            count[i] <= 0; 
        end

        for (j = 0; j < 16; j = j + 1) begin
            count[history[j]] <= count[history[j]] + 1;
        end
        // C?p nh?t tr?ng s? (tr?ng s? gi?m khi s? xu?t hi?n nhi?u)
        for (i = 0; i < 10; i = i + 1)
            weights[i*8 +: 8] <= 16 - count[i]; // Tr?ng s? cao h?n cho s? ít xu?t hi?n
    end
endmodule
