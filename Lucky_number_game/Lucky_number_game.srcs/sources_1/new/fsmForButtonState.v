`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 11:20:48 AM
// Design Name: 
// Module Name: fsmForButtonState
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

module fsmForButtonState(
    input clk,                                      /*This is clk from Arty-z7*/
    input clk_button,                               /*This clk for 400Hz - 2.5ms read button*/
    input rst,                                      /*This is reset signal*/
    input[3:0] button_in,                           /*This for read button value from Arty-z7*/
    output reg[7:0] button_state                    /*This is for button state button_state[i*2 +:2] = 
                                                        button i*/
    );
    
    wire[3:0] button_pressed_wire;
    wire[3:0] button_pressed_hold_wire;
      
    readButtonWithDebounce read_button_debounce_inst(
    .clk(clk),
    .clk_button(clk_button),
    .rst(rst),
    .button_in(button_in),
    .button_pressed(button_pressed_wire),
    .button_pressed_hold(button_pressed_hold_wire)
    );
    
    integer i;
    
    /*Check Fsm_for_button.drawio for FSM*/
    always @(posedge clk_button or posedge rst) begin
        if(rst) begin
            button_state <= 8'b00000000;
        end
        else begin
          if(clk_button) begin  
            for(i=0;i<4;i=i+1) begin
                case(button_state[i*2 +:2])
                    `BUTTON_STATE_RELEASED: begin
                        if(button_pressed_wire[i]) begin
                            button_state[i*2 +:2] <= `BUTTON_STATE_PRESSED;
                        end
                    end
                    `BUTTON_STATE_PRESSED: begin
                        if(!button_pressed_wire[i]) begin
                            button_state[i*2 +:2] <= `BUTTON_STATE_RELEASED;
                        end
                        else begin
                            if(button_pressed_hold_wire[i]) begin
                                button_state[i*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;
                            end
                        end
                    end
                    `BUTTON_STATE_PRESSED_HOLD: begin
                        if(!button_pressed_wire[i]) begin
                            button_state[i*2 +:2] <= `BUTTON_STATE_RELEASED;
                        end              
                    end
                    default: begin
                        button_state[i*2 +:2] <= `BUTTON_STATE_RELEASED;
                    end
                endcase      
            end
          end /*End if clk*/  
        end    
    end
    
endmodule
