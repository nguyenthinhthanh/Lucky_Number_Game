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
    input wire clk,
    /*input wire clk_system,*/
    input wire rst,
    input wire rx,
    output wire tx,
    output reg[7:0] bluetooth_button_state
);
    wire [7:0] data_in;
    reg [7:0] data_out;
    wire tx_busy;
    wire rx_ready;
    
    reg data_valid;
    reg [3:0] state;
    reg [31:0] delay_counter;  // Delay counter for sending
    
    reg[7:0] bluetooth_button_state_reg;                  /*This just is reg for store bluetooth button state*/

    wire clk_system;

    parameter TARGET_CLK_FREQ = 400;            /*This clk for every 400Hz - 2.5ms read button value */
    
    frequencyDivider #(                                     /*This is frequency divider to make clk for systems*/ 
        .TARGET_CLK_FREQ(TARGET_CLK_FREQ)                   //  @input : parameter TARGET_CLK_FREQ*/
    ) frequency_for_button_read_inst(                       //  @output : clk for systems
        .clk(clk),
        .rst(rst),
        .clk_out(clk_system)
    );

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
    
    reg [7:0] counter;
    
    always @(posedge /*clk*/ clk_system or posedge rst) begin
        if(rst) begin
            bluetooth_button_state <= 8'b0000_0000;
            bluetooth_button_state_reg <= 8'b0000_0000;
        end
        else begin
            case (data_out)
                8'h41: begin                /*A char*/
                    bluetooth_button_state_reg[0*2 +:2] <= `BUTTON_STATE_PRESSED;
                end
                8'h42: begin                /*B char*/
                    bluetooth_button_state_reg[1*2 +:2] <= `BUTTON_STATE_PRESSED;
                end
                8'h43: begin                /*C char*/
                    bluetooth_button_state_reg[2*2 +:2] <= `BUTTON_STATE_PRESSED;
                end
                8'h44: begin                /*D char*/
                    bluetooth_button_state_reg[3*2 +:2] <= `BUTTON_STATE_PRESSED;
                end
                8'h44: begin                /*E char*/
                    bluetooth_button_state_reg[0*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD; 
                end
                8'h46: begin                /*F char*/
                    bluetooth_button_state_reg[1*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;    
                end
                8'h47: begin                /*G char*/
                    bluetooth_button_state_reg[2*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD; 
                end
                8'h48: begin                /*H char*/
                    bluetooth_button_state_reg[3*2 +:2] <= `BUTTON_STATE_PRESSED_HOLD;  
                end
                /*If not have bluetooth char, button state default BUTTON_STATE_RELEASED*/
                //default: bluetooth_button_state_reg <= 8'b0000_0000;
                /*Just to test*/ 
                default: bluetooth_button_state_reg <= bluetooth_button_state_reg;
            endcase
            
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
                end
                1: begin
                    if (tx_busy) begin
                        data_valid <= 0;
                        state <= 2;
                    end
                end
                2: begin
                    
                    /*if(counter < 1) begin
                        if (!tx_busy) begin
                            counter <= counter + 1;
                            state <= 0;
                        end
                    end
                    else begin
                        state <= 2;
                    end*/
                    if (!tx_busy) begin
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule
