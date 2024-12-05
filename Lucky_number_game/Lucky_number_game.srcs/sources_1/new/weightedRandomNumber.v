`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 12:37:34 PM
// Design Name: 
// Module Name: weightedRandomNumber
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


module weightedRandomNumber(
    input wire clk,
    input wire rst,
    input wire [79:0] weights, // Tr?ng s? t? b? t�nh to�n
    input[3:0] random_number_in,
    output reg [3:0] random_num     // K?t qu? quay
);
    reg break;
    reg [11:0] cumulative_weights [0:9]; // Tr?ng s? t�ch l?y
    reg [11:0] random_value;             // Gi� tr? ng?u nhi�n
    integer i;
    
    reg [3:0] random_num_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 10; i = i + 1) begin
                cumulative_weights[i] <= 0;    
             end
             random_num <= 0;
             random_num_reg <= 0;
             break <= 0;
        end else begin
            // T�nh tr?ng s? t�ch l?y
            cumulative_weights[0] <= weights[0*8 +:8];
            for (i = 1; i < 10; i = i + 1)
                cumulative_weights[i] <= cumulative_weights[i - 1] + weights[i*8 +:8];

            // Sinh gi� tr? ng?u nhi�n
            random_value <= random_number_in % cumulative_weights[9];

            // Ch?n s? d?a tr�n tr?ng s? t�ch l?y
            break <= 0;
            for (i = 0; i < 10; i = i + 1) begin
                if (!break && random_value < cumulative_weights[i]) begin
                    random_num_reg <= i;
                    
                    break <= 1;
                end
            end
            
            random_num <= random_num_reg;
        end
    end
endmodule

