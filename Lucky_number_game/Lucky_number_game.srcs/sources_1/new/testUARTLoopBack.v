`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 02:04:51 PM
// Design Name: 
// Module Name: testUARTLoopBack
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


module testUARTLoopBack(
    input wire clk,
    input wire rst,
    input wire rx,
    output wire tx
);
    wire [7:0] data_in;
    reg [7:0] data_out;
    wire tx_busy;
    wire rx_ready;
    reg data_valid;
    reg [3:0] state;
    
    // K?t n?i UART module
    uart uart (
        .clk(clk),
        .reset(rst),
        .rx(rx),
        .tx(tx),
        .tx_data(data_out),
        .rx_data(data_in),
        .tx_start(data_valid),
        .tx_busy(tx_busy),
        .rx_ready(rx_ready)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (rx_ready) begin
                        data_out <= data_in;
                        data_valid <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    if (tx_busy) begin
                        data_valid <= 0;
                        state <= 2;
                    end
                end
                2: begin
                    if (!tx_busy) begin
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule
