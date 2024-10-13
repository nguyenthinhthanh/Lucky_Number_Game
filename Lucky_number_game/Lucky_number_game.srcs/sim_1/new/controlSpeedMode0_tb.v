`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 05:32:46 PM
// Design Name: 
// Module Name: controlSpeedMode0_tb
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


module controlSpeedMode0_tb;

reg clk;
reg rst;
reg button;
reg [1:0] game_mode;

wire done_signal;
wire getNumber;
wire [3:0] random_number;

controlSpeedMode0 uut(
    .clk(clk),
    .rst(rst),
    .button(button),
    .game_mode(game_mode),
    .done_signal(done_signal),
    .getNumber(getNumber)
);

generateRandomNumber uut1(
    .clk(clk),
    .rst(rst),
    .getNumber(getNumber),
    .done_signal(done_signal),
    .random_number(random_number)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("Time no: %dns Randon number : %b binary %d decimal",$time, random_number, random_number);
end

initial begin
    game_mode = 2'b00;
    button = 0;
    rst = 1;
    #10
    rst = 0;
    #10
    
    $display("This is test Mode 0 \n");
    
    for(integer i =0;i<10;i =i+1) begin
        #20
        button = 1;
        #20
        button = 0;        
    end
    
    #10
    
    $display("This is test Mode 1 \n");
    game_mode = 2'b01;
    button = 1;
    #500
    button = 0;
    
    #10
    $finish;    
end

endmodule
