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
        forever #5 clk = ~clk; // Thay ??i tr?ng th�i m?i 5ns
    end

    // T?o c�c t�nh hu?ng ki?m th?
    initial begin
        // Kh?i t?o
        rst = 1;            // ??t t�n hi?u reset
        button_in = 4'b0000; // Kh�ng nh?n n�t
        #10;

        rst = 0;            // B? reset
        #10;

        // Ki?m th? nh?n n�t l?n l??t cho t?ng LED
        for (integer i = 0; i < 4; i = i + 1) begin
            // Nh?n n�t
            button_in = 4'b0001 << i; // Nh?n n�t th? i
            #10; // Gi? n�t nh?n trong m?t kho?ng th?i gian

            // Th? n�t
            button_in = 4'b0000;
            #10; // Th?i gian gi?a c�c nh?n n�t
        end

        // Ki?m tra tr?ng th�i LED sau khi nh?n n�t
        #10;
        $finish; // K?t th�c m� ph?ng
    end

    // Ki?m tra tr?ng th�i LED
    initial begin
        $monitor("At time %t: button_in = %b, led = %b", $time, button_in, led);
    end
endmodule
