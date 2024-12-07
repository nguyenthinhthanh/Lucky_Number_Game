`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 03:50:41 PM
// Design Name: 
// Module Name: UART_HelloWorld
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


module UART_HelloWorld #(
    parameter CLOCK_RATE = 125000000, // T?n s? clock c?a h? th?ng
    parameter BAUD_RATE = 9600         // T?c ?? baud
)(
    input wire clk,                    // Clock ??u vào
    input wire reset,                  // Tín hi?u reset
    output wire tx                     // ??u ra UART TX
);

    // Chu?i c?n g?i
    reg [7:0] message [0:11];
    initial begin
        message[0]  = "H";
        message[1]  = "e";
        message[2]  = "l";
        message[3]  = "l";
        message[4]  = "o";
        message[5]  = " ";
        message[6]  = "W";
        message[7]  = "o";
        message[8]  = "r";
        message[9]  = "l";
        message[10] = "d";
        message[11] = "\n"; // Ký t? xu?ng dòng
    end

    // Tín hi?u clock t? BaudRateGenerator
    wire txClk;

    // Tín hi?u ?i?u khi?n Uart8Transmitter
    reg txStart = 0;
    reg [7:0] txData = 0;
    wire txBusy;
    wire txDone;

    // Baud Rate Generator
    BaudRateGenerator #(
        .CLOCK_RATE(CLOCK_RATE),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen (
        .clk(clk),
        .rxClk(),   // Không s? d?ng RX
        .txClk(txClk)
    );

    // Uart8Transmitter
    Uart8Transmitter txInst (
        .clk(txClk),
        .en(1),          // Luôn kích ho?t
        .start(txStart),
        .in(txData),
        .busy(txBusy),
        .done(txDone),
        .out(tx)
    );

    // FSM ?? ?i?u khi?n truy?n d? li?u
    reg [3:0] state = 0;
    reg [3:0] index = 0;

    always @(posedge txClk or posedge reset) begin
        if (reset) begin
            state <= 0;
            index <= 0;
            txStart <= 0;
        end else begin
            case (state)
                0: begin
                    // Ch? tín hi?u không b?n ?? b?t ??u
                    if (!txBusy) begin
                        txData <= message[index];
                        txStart <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    // Ch? hoàn t?t truy?n
                    txStart <= 0; // H?y tín hi?u start
                    if (txDone) begin
                        if (index < 11) begin
                            index <= index + 1; // Truy?n ký t? ti?p theo
                            state <= 0;
                        end else begin
                            state <= 2; // Hoàn t?t chu?i
                        end
                    end
                end
                2: begin
                    // K?t thúc, gi? tr?ng thái
                    state <= 2;
                end
            endcase
        end
    end

endmodule


