`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 04:35:26 PM
// Design Name: 
// Module Name: makeRgbBlinky
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


module makeRgbBlinky(
    input clk,
    input rst,
    input rgb_state,
    output reg rgb
    );
    
    /*counter and flag for blinking led*/
    integer counter_b;
    
    /*frequency for led blinking*/
    localparam integer FREQ_BLINKY = 200;         
  
    
    always @(posedge clk or posedge rst)   begin 
        if(rst) begin 
            counter_b <= 0;
            rgb <= 0;
        end      
        else    begin
            case(rgb_state)
                1'b1:   begin
                    /*count to FREQ_BLINKY*/
                    if(counter_b < FREQ_BLINKY)    begin
                        counter_b <= counter_b + 1;
                        
                        if(counter_b == FREQ_BLINKY)    begin
                            rgb <= ~rgb;
                            counter_b <= 0;
                        end
                    end
                    else    begin
                        rgb <= ~rgb;
                        counter_b <= 0;
                    end  
                end 
                default: ;   
            endcase
        end
    end
endmodule

