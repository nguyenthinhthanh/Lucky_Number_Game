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
    wire [7:0] data_out;
    wire data_ready;
    reg [7:0] data_in;
    reg data_valid;
    reg [31:0] counter;     // Counter for 2 seconds delay
    reg [3:0] state;
    reg [3:0] char_index;
    
    // Chu?i "Hello world" ???c mã hóa d??i d?ng b?ng ký t?
    reg [7:0] hello_world [0:11];

    initial begin
        hello_world[0] = "H";
        hello_world[1] = "e";
        hello_world[2] = "l";
        hello_world[3] = "l";
        hello_world[4] = "o";
        hello_world[5] = " ";
        hello_world[6] = "w";
        hello_world[7] = "o";
        hello_world[8] = "r";
        hello_world[9] = "l";
        hello_world[10] = "d";
        hello_world[11] = "\n";  // D?u xu?ng dòng sau t? "world"
        data_valid = 0;
        char_index = 0;
        state = 0;
        counter = 0;
    end

    // K?t n?i UART module
    myUART uart (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .data_in(data_in),
        .data_out(data_out),
        .data_valid(data_valid),
        .data_ready(data_ready)
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
                    if (char_index < 12) begin
                        data_in <= hello_world[char_index];
                        data_valid <= 1;
                        char_index <= char_index + 1;
                        state <= 2;
                    end else begin
                        char_index <= 0; // Reset index to start sending "Hello world" again
                        state <= 0;
                    end
                end
                2: begin
                    if (data_ready) begin
                        data_valid <= 0;
                        state <= 1;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule



