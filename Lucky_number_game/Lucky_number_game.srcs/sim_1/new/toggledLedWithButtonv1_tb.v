`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 12:23:55 PM
// Design Name: 
// Module Name: toggledLedWithButtonv1_tb
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


module toggledLedWithButtonv1_tb();
    reg clk;
    reg rst;
    reg [3:0] button_in;
    wire [3:0] led;

    toggleLedWithButton uut (
        .clk(clk),
        .rst(rst),
        .button_in(button_in),
        .led(led)
    );
    
    // T?o xung ??ng h?
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Thay ??i tr?ng thái m?i 5ns
    end

    // T?o các tình hu?ng ki?m th?
    initial begin
        // Kh?i t?o
        rst = 1;            // ??t tín hi?u reset
        button_in = 4'b0000; // Không nh?n nút
        #10;

        rst = 0;            // B? reset
        #10;

        // Ki?m th? nh?n nút l?n l??t cho t?ng LED
        for (integer i = 0; i < 4; i = i + 1) begin
            // Nh?n nút
            button_in = 4'b0001 << i; // Nh?n nút th? i
            #10; // Gi? nút nh?n trong m?t kho?ng th?i gian

            // Th? nút
            button_in = 4'b0000;
            #10; // Th?i gian gi?a các nh?n nút
        end

        // Ki?m tra tr?ng thái LED sau khi nh?n nút
        #10;
        $finish; // K?t thúc mô ph?ng
    end

    // Ki?m tra tr?ng thái LED
    initial begin
        $monitor("At time %t: button_in = %b, led = %b", $time, button_in, led);
    end
endmodule
