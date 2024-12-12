`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 08:07:41 PM
// Design Name: 
// Module Name: controlGameWithBluetooth
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

module controlGameWithBluetooth(
    input wire clk,                         /*This is clk from Arty-z7*/
    input wire clk_system,                  /*This clk 400Hz - 2.5ms for system*/
    input wire rst,                         /*This is reset signal*/
    input wire rx,                          /*This is tx for Uart communicate*/
    output wire tx,                         /*This is rx for Uart communicate*/
    output reg[7:0] bluetooth_button_state  /*This is bluetooth button state*/
);
    wire [7:0] data_in;
    reg [7:0] data_out;
    reg [7:0] data_out_tmp;
    wire tx_busy;
    wire rx_ready;
    
    reg data_valid;
    reg [3:0] state;
    reg [31:0] delay_counter;                       /*Delay counter for sending*/
    
    reg[7:0] bluetooth_button_state_reg;            /*This just is reg for store bluetooth button state*/

    /*Connect uart module*/
    myUART uart (
        .clk(clk),
        .reset(rst),
        .rx(rx),
        .tx(tx),
        .tx_data(data_out),
        .rx_data(data_in),
        .tx_start(data_valid),
        .tx_busy(tx_busy),
        .rx_ready(rx_ready)
    );
    
    reg clear;
    reg flag;
    reg [7:0] counter;
    
    integer i;
    
    always @(posedge /*clk*/ clk_system or posedge rst) begin
        if(rst) begin
            flag <= 0;
            
            bluetooth_button_state <= 8'b0000_0000;
            bluetooth_button_state_reg <= 8'b0000_0000;
        end
        else begin
            if(!flag) begin
                case (data_out)
                    8'h41: begin                /*A char*/
                        flag <= 1;
                        bluetooth_button_state_reg[0*2 +:2] <= `BUTTON_STATE_PRESSED;
                    end
                    8'h42: begin                /*B char*/
                        flag <= 1;
                        bluetooth_button_state_reg[1*2 +:2] <= `BUTTON_STATE_PRESSED;
                    end
                    8'h43: begin                /*C char*/
                        bluetooth_button_state_reg[2*2 +:2] <= `BUTTON_STATE_PRESSED;
                    end
                    8'h44: begin                /*D char*/
                        flag <= 1;
                        bluetooth_button_state_reg[3*2 +:2] <= `BUTTON_STATE_PRESSED;
                    end
                    8'h45: begin                /*E char*/
                        //flag <= 1;
                        bluetooth_button_state_reg[0*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD; 
                    end
                    8'h46: begin                /*F char*/
                        //flag <= 1;
                        bluetooth_button_state_reg[1*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;    
                    end
                    8'h47: begin                /*G char*/
                        //flag <= 1;
                        bluetooth_button_state_reg[2*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD; 
                    end
                    8'h48: begin                /*H char*/
                        //flag <= 1;
                        bluetooth_button_state_reg[3*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;  
                    end
                    8'h53: begin                /*S char* stop hold*/
                        flag <= 1;
                        bluetooth_button_state_reg <= 8'b0000_0000;
                    end
                    /*If not have bluetooth char, button state default BUTTON_STATE_RELEASED*/
                    default: begin
                        for(i=0;i<`NUM_OF_BUTTON;i=i+1) begin
                            if(bluetooth_button_state_reg[i*2 +:2] == `BUTTON_STATE_PRESSED_HOLD) begin
                                bluetooth_button_state_reg <= bluetooth_button_state_reg;
                            end
                            else begin
                                bluetooth_button_state_reg <= 8'b0000_0000; 
                            end
                        end
                        /*bluetooth_button_state_reg <= 8'b0000_0000;*/                   
                    end
                    /*Just to test*/ 
                    //default: bluetooth_button_state_reg <= bluetooth_button_state_reg;
                endcase
                
            end
            else begin
                flag <= 0;
                bluetooth_button_state_reg <= 8'b0000_0000;
            end
            bluetooth_button_state <= bluetooth_button_state_reg;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
        
            data_valid <= 0;
            state <= 0;
            delay_counter <= 0;
        end else begin
            case (state)
                0: begin
                    if (rx_ready) begin
                        data_out <= data_in;
                        
//                        if(data_out == 8'h21) begin             /*! char to end*/
//                            data_valid <= 0;
//                            state <= 0;
//                        end
//                        else begin
//                            data_valid <= 1;
//                            state <= 1;
//                        end
                        data_valid <= 1;
                        state <= 1;
                    end
                    else begin
                        if(flag) begin
                            data_out <= 0;
                        end
                    end
                end
                1: begin
                    if (tx_busy) begin
                        data_valid <= 0;
                        state <= 2;
                    end
                end
                2: begin
                    if (!tx_busy) begin
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule
