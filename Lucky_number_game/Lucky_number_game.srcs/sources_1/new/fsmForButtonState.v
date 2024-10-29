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

/*This module is fsm for button state, button state will input for fsmLuckyNumberGame*/
module fsmForButtonState(
    input clk,                                          /*This is clk from Arty-z7*/
    input clk_system,                                   /*This clk 400Hz - 2.5ms for read button and system*/
    input rst,                                          /*This is reset signal*/
    input[3:0] button_in,                               /*This for read button value from Arty-z7*/
    output reg[7:0] button_state                        /*This is for button state button_state[i*2 +:2] = button i*/
    );
    
    wire[3:0] button_pressed_wire;                      /*This is button pressed wire for read signal button pressed
                                                            @from : readButtonWithDebounce module*/
    wire[3:0] button_pressed_hold_wire;                 /*This is button pressed hold wire for read signal button pressed hold
                                                            @from : readButtonWithDebounce module*/
    reg[7:0] button_state_reg;                          /*This just is reg for store button state*/
      
    readButtonWithDebounce read_button_debounce_inst(   /*This module for read button without debounce*/
    .clk(clk),                                          //  @input : button_in[3:0] from Arty-z7
    .clk_button(clk_system),                            //  @output : button_pressed[3:0], button_pressed_hold[3:0] 
    .rst(rst),                                          //  That is signal button after reslove debounce
    .button_in(button_in),
    .button_pressed(button_pressed_wire),
    .button_pressed_hold(button_pressed_hold_wire)
    );
    
    integer i;                                          /*This integer for travels between buttons*/
    
    /*Check Fsm_for_button.drawio on https://github.com/nguyenthinhthanh/Lucky_Number_Game for FSM and more detail*/
    always @(posedge clk_system or posedge rst) begin
        if(rst) begin
            button_state <= 8'b00_00_00_00;
            button_state_reg <= 8'b00_00_00_00;
        end
        else begin
          if(clk_system) begin  
            for(i=0;i<4;i=i+1) begin
                case(button_state_reg[i*2 +:2])
                    `BUTTON_STATE_RELEASED: begin
                        if(button_pressed_wire[i]) begin    /*If button[i] is pressed*/
                            button_state_reg[i*2 +:2] <= `BUTTON_STATE_PRESSED;
                        end
                        else begin
                            if(button_pressed_hold_wire[i]) begin   /*If button[i] is pressed and hold*/
                                button_state_reg[i*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;
                            end
                        end
                    end
                    `BUTTON_STATE_PRESSED: begin
                        if(!button_pressed_wire[i]) begin   /*If button[i] is release*/
                            button_state_reg[i*2 +:2] <= `BUTTON_STATE_RELEASED;
                        end
                        else begin
                            if(button_pressed_hold_wire[i]) begin   /*If button[i] is pressed and hold*/
                                button_state_reg[i*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;
                            end
                        end
                    end
                    `BUTTON_STATE_PRESSED_HOLD: begin
                        if(!button_pressed_hold_wire[i]) begin      /*If button[i] is release*/
                            button_state_reg[i*2 +:2] <= `BUTTON_STATE_RELEASED;
                        end              
                    end
                    default: begin
                        button_state_reg[i*2 +:2] <= button_state_reg[i*2 +:2];
                    end
                endcase      
            end
            /*Sync button state value*/
            button_state <= button_state_reg;
          end /*End if clk*/  
        end    
    end
    
endmodule
