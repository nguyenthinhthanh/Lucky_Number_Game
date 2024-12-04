`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 10:42:38 AM
// Design Name: 
// Module Name: toggleLedWithIrRemote
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


module toggleLedWithIrRemote(
    input clk,          // Clock 125 MHz
    input rst,          // Reset
    input ir_in,        // Tín hi?u t? m?t IR
    output led          // ?i?u khi?n ?èn
);
    wire clk_div;
    wire [31:0] ir_data;
    wire ir_valid;


    parameter TARGET_CLK_FREQ = 38000;            /*This clk for every 400Hz - 2.5ms read button value */
    
    frequencyDivider #(                                     /*This is frequency divider to make clk for systems*/ 
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)                   //  @input : parameter TARGET_CLK_FREQ*/
    ) frequency_for_button_read_inst(                       //  @output : clk for systems
        .clk(clk),
        .rst(rst),
        .clk_out(clk_div)
    );

    irReceiver u2 (
        .clk(clk_div),
        .rst(rst),
        .ir_in(ir_in),
        .data(ir_data),
        .valid(ir_valid)
    );

    ledIrController u3 (
        .clk(clk),
        .rst(rst),
        .ir_data(ir_data),
        .ir_valid(ir_valid),
        .led(led)
    );
endmodule
