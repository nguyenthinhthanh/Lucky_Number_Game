`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 10:40:54 AM
// Design Name: 
// Module Name: irReceiver
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


module irReceiver(
    input clk,              // Clock sau khi chia t?n
    input rst,              // Reset
    input ir_in,            // Tín hi?u t? m?t IR
    output reg [31:0] data, // D? li?u ?ã gi?i mã
    output reg valid        // Tín hi?u h?p l?
);
    reg [31:0] shift_reg;
    reg [5:0] bit_count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            bit_count <= 0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (ir_in == 0) begin // Phát hi?n start bit
                        state <= 1;
                        bit_count <= 0;
                        shift_reg <= 0;
                        valid <= 0;
                    end
                end
                1: begin
                    shift_reg <= {shift_reg[30:0], ir_in};
                    bit_count <= bit_count + 1;
                    if (bit_count == 31) begin
                        data <= shift_reg;
                        valid <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
