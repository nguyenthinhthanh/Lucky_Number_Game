`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 08:03:47 PM
// Design Name: 
// Module Name: generateRandomNumber
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

/*This module using Linear Feedback Shift Register (LFSR) to generate random number*/
module generateRandomNumber(
    input clk,          // Clock input
    input rst,          // Reset input
    input getNumber,    // Get random number when have signal button input
    output reg done_signal, // Signal when done get random number
    output reg[3:0]  random_number  // 4-bit random number from 0-9    
    );
    
    reg[7:0] lfsr = 8'b10101010;      // 8 bit LFSR registor default value
    wire feedback;      
    // To generate new bit
    assign feedback = lfsr[7]^lfsr[5]^lfsr[4]^lfsr[3];
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            done_signal <= 0;
            lfsr <= 8'b10101010;   
        end
        else begin
           // Shift LFSR and apply feedback
            lfsr <= {lfsr[6:0],feedback};
            if(getNumber) begin
                // When have button signal generate new random number
                random_number <=  lfsr[3:0] % 10;
                done_signal <= 1; 
            end
            else begin
                done_signal <= 0;
            end
        end
    end 
endmodule
