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
    output wire tx
);
    reg [7:0] data_in;
    reg data_valid;
    wire tx_busy;
    reg [31:0] counter;     // Counter for 2 seconds delay
    reg [3:0] state;
    reg [3:0] char_index;
    
    // Chu?i "I am iron man" ???c mã hóa d??i d?ng b?ng ký t?
    reg [7:0] message [0:12];

    initial begin
        message[0] = "A";
        message[1] = "T";
        /*message[0] = "I";
        message[1] = " ";
        message[2] = "a";
        message[3] = "m";
        message[4] = " ";
        message[5] = "i";
        message[6] = "r";
        message[7] = "o";
        message[8] = "n";
        message[9] = " ";
        message[10] = "m";
        message[11] = "a";
        message[12] = "n";
        data_valid = 0;
        char_index = 0;
        state = 0;
        counter = 0;*/
    end

    // K?t n?i UART module
    uart_tx uart (
        .clk(clk),
        .reset(rst),
        .tx_start(data_valid),
        .tx_data(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_valid <= 0;
            char_index <= 0;
            state <= 0;
            counter <= 0;
        end else begin
            case (state)
                0: begin
                    // ??m th?i gian 2 giây
                    if (counter < (2 * 125000000)) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        state <= 1;
                    end
                end
                1: begin
                    if (char_index < 2) begin
                        if (!tx_busy) begin
                            data_in <= message[char_index];
                            data_valid <= 1;
                            char_index <= char_index + 1;
                            state <= 2;
                        end
                    end else begin
                        char_index <= 0; // Reset index to start sending "I am iron man" again
                        state <= 0;
                    end
                end
                2: begin
                    if (tx_busy) begin
                        data_valid <= 0;
                        state <= 1;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule
