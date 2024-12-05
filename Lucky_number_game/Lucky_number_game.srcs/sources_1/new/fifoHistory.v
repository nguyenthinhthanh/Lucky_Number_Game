`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 12:17:29 PM
// Design Name: 
// Module Name: fifoHistory
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


module fifoHistory(
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,   // S? k?t qu? quay m?i (0-9)
    input wire write_en,        // Tín hi?u ghi
    output reg[63:0] history // L?ch s? quay 16x 4bit number
);
    reg[63:0] history_reg;

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) begin
                history_reg[i*4 +: 4] <= 4'b0000;
                history[i*4 +: 4] <= 4'b0000;
            end
        end 
        else if (write_en) begin
            for (i = 15; i > 0; i = i - 1) begin
                history_reg[i*4 +: 4] <= history_reg[(i - 1)*4 +: 4];  // D?ch xu?ng
            end
            history_reg[0*4 +: 4] <= data_in;            // L?u k?t qu? m?i
        end
        
        history <= history_reg;
    end
endmodule
