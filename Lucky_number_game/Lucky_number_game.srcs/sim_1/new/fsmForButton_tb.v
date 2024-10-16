`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 03:47:00 PM
// Design Name: 
// Module Name: fsmForButton_tb
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

`include "header.vh"

module fsmForButton_tb;
    
reg clk;
reg rst;
reg [3:0] button_in;

wire [3:0] button_read_done;
wire [7:0] button_state;

fsmForButtonState uut (
    .clk(clk),
    .rst(rst),
    .button_in(button_in),
    .button_state(button_state),
    .button_read_done(button_read_done)
);

always #10 clk = ~clk;

initial begin
    // print
    $monitor($time, 
             " clk=%b rst=%b button_in=%b | state0=%b state1=%b state2=%b state3=%b | read_done=%b",
             clk, rst, button_in, 
             button_state[1:0], button_state[3:2], button_state[5:4], button_state[7:6], 
             button_read_done);
end

initial begin

    clk = 0;
    rst = 1;
    button_in = 4'b0000;

    #50 rst = 0;

    #100 button_in = 4'b0001;  
    #100 button_in = 4'b0010;  
    #100 button_in = 4'b0100;  
    #100 button_in = 4'b1000;  

    #50 button_in = 4'b0000;  

    
    #500;
    $finish;
    
    end
endmodule
