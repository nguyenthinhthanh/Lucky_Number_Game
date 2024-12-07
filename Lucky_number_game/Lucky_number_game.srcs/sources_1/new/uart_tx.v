`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 04:18:15 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter CLOCK_FREQ = 125000000;
    parameter BAUD_RATE = 9600;
    localparam integer BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    localparam STATE_IDLE = 3'b000;
    localparam STATE_START = 3'b001;
    localparam STATE_DATA = 3'b010;
    localparam STATE_STOP = 3'b011;
    
    reg [2:0] state;
    reg [2:0] bit_idx;
    reg [15:0] bit_timer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_idx <= 3'd0;
            bit_timer <= 16'd0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (tx_start) begin
                        state <= STATE_START;
                        tx_busy <= 1'b1;
                        bit_timer <= BIT_PERIOD;
                    end
                end
                STATE_START: begin
                    if (bit_timer == 16'd0) begin
                        tx <= 1'b0; // start bit
                        state <= STATE_DATA;
                        bit_idx <= 3'd0;
                        bit_timer <= BIT_PERIOD;
                    end else begin
                        bit_timer <= bit_timer - 1;
                    end
                end
                STATE_DATA: begin
                    if (bit_timer == 16'd0) begin
                        tx <= tx_data[bit_idx];
                        bit_idx <= bit_idx + 1;
                        bit_timer <= BIT_PERIOD;
                        if (bit_idx == 3'd7) begin
                            state <= STATE_STOP;
                        end
                    end else begin
                        bit_timer <= bit_timer - 1;
                    end
                end
                STATE_STOP: begin
                    if (bit_timer == 16'd0) begin
                        tx <= 1'b1; // stop bit
                        state <= STATE_IDLE;
                        tx_busy <= 1'b0;
                    end else begin
                        bit_timer <= bit_timer - 1;
                    end
                end
                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule

