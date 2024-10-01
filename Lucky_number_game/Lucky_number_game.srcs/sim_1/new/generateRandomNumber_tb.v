`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 08:55:40 PM
// Design Name: 
// Module Name: generateRandomNumber_tb
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


module generateRandomNumber_tb;

reg clk;
reg rst;
reg getNumber;

wire[3:0] random_number;

generateRandomNumber uut(
    .clk(clk),
    .rst(rst),
    .getNumber(getNumber),
    .random_number(random_number)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("Time: %dns Randon number : %b binary %d decimal",$time, random_number, random_number);
end

initial begin
    rst = 1;
    #10
    rst = 0;
    #10
    
    for(integer i =0;i<10;i =i+1) begin
        getNumber = 1;
        #10;
        getNumber = 0;
        #10;
    end
    
    #10
    $finish;    
end

endmodule
