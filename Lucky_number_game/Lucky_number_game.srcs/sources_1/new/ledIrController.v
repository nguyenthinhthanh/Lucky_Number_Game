`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 10:43:53 AM
// Design Name: 
// Module Name: ledIrController
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


module ledIrController(
    input clk,
    input rst,
    input [31:0] ir_data,  // D? li?u t? IR
    input ir_valid,        // T�n hi?u h?p l?
    output reg led         // ?�n
);
    reg led_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_reg <= 0;
            led <= 0;
        end else if (ir_valid) begin
            case (ir_data[23:16]) // Ki?m tra m� n�t
                8'h10: led_reg <= ~led_reg;  // N�t A
                8'h810: led_reg <= ~led_reg;  // N�t B
                8'h210: led_reg <= ~led_reg; // N�t C
                8'hA10: led_reg <= ~led_reg;
                8'h610: led_reg <= ~led_reg;
                8'hE10: led_reg <= ~led_reg;
                8'h110: led_reg <= ~led_reg;
                8'hC10: led_reg <= ~led_reg;
                default: led_reg <= ~led_reg; // C�c n�t kh�c
            endcase
            
            led <= led_reg;
        end
    end
endmodule