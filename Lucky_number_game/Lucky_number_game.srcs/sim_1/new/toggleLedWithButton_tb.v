`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 04:28:44 PM
// Design Name: 
// Module Name: toggleLedWithButton_tb
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


module toggleLedWithButton_tb();
    reg clk;
    reg rst;
    reg [3:0] button_in;
    wire [3:0] button_read_done;
    wire [3:0] led;

    toggleLedWithButton uut (
        .clk(clk),
        .rst(rst),
        .button_in(button_in),
        .button_read_done(button_read_done),
        .led(led)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Chu k? 10ns
    end

    initial begin
        rst = 1;
        button_in = 4'b0000;
        #20; 
        
       
        rst = 0;
        #20;

        
        button_in[0] = 1;
        #10;
        button_in[0] = 0;
        #50;  
        
        
        button_in[1] = 1;
        #10;
        button_in[1] = 0;
        #50;

        
        button_in[2] = 1;
        #100;
        button_in[2] = 0;
        #50;

        // K?t thúc mô ph?ng
        $stop;
    end
endmodule
