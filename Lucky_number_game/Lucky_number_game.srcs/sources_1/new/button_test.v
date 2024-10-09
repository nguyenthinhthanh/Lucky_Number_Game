`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2024 07:45:56 PM
// Design Name: 
// Module Name: button_test
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


module button_test(
    input[3:0] button,
    output reg[3:0] led
    );
    
    always@(button) begin
        case(button)
            0:  led = 4'b0000;
            1:  led = 4'b0001;
            2:  led = 4'b0010;
            4:  led = 4'b0100;
            8:  led = 4'b1000;
            
            default: led = 4'b0000;
        endcase
    end
    
endmodule
