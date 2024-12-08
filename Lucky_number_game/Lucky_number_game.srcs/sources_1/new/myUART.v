`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 02:02:45 PM
// Design Name: 
// Module Name: myUART
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


module myUART(
    input wire clk,
    input wire reset,
    input wire rx,
    output reg tx,
    input wire [7:0] tx_data,
    output reg [7:0] rx_data,
    input wire tx_start,
    output reg tx_busy,
    output reg rx_ready
);
    parameter CLOCK_FREQ = 125000000;
    parameter BAUD_RATE = 9600;
    localparam integer BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    // Transmitter state machine
    localparam TX_IDLE = 3'b000;
    localparam TX_START = 3'b001;
    localparam TX_DATA = 3'b010;
    localparam TX_STOP = 3'b011;
    
    reg [2:0] tx_state;
    reg [2:0] tx_bit_idx;
    reg [15:0] tx_bit_timer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            tx_state <= TX_IDLE;
            tx_bit_idx <= 3'd0;
            tx_bit_timer <= 16'd0;
        end else begin
            case (tx_state)
                TX_IDLE: begin
                    if (tx_start) begin
                        tx_state <= TX_START;
                        tx_busy <= 1'b1;
                        tx_bit_timer <= BIT_PERIOD;
                    end
                end
                TX_START: begin
                    if (tx_bit_timer == 16'd0) begin
                        tx <= 1'b0; // start bit
                        tx_state <= TX_DATA;
                        tx_bit_idx <= 3'd0;
                        tx_bit_timer <= BIT_PERIOD;
                    end else begin
                        tx_bit_timer <= tx_bit_timer - 1;
                    end
                end
                TX_DATA: begin
                    if (tx_bit_timer == 16'd0) begin
                        tx <= tx_data[tx_bit_idx];
                        tx_bit_idx <= tx_bit_idx + 1;
                        tx_bit_timer <= BIT_PERIOD;
                        if (tx_bit_idx == 3'd7) begin
                            tx_state <= TX_STOP;
                        end
                    end else begin
                        tx_bit_timer <= tx_bit_timer - 1;
                    end
                end
                TX_STOP: begin
                    if (tx_bit_timer == 16'd0) begin
                        tx <= 1'b1; // stop bit
                        tx_state <= TX_IDLE;
                        tx_busy <= 1'b0;
                    end else begin
                        tx_bit_timer <= tx_bit_timer - 1;
                    end
                end
                default: tx_state <= TX_IDLE;
            endcase
        end
    end

    // Receiver state machine
    localparam RX_IDLE = 3'b000;
    localparam RX_START = 3'b001;
    localparam RX_DATA = 3'b010;
    localparam RX_STOP = 3'b011;
    
    reg [2:0] rx_state;
    reg [2:0] rx_bit_idx;
    reg [15:0] rx_bit_timer;
    reg [7:0] rx_shift_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_ready <= 1'b0;
            rx_state <= RX_IDLE;
            rx_bit_idx <= 3'd0;
            rx_bit_timer <= 16'd0;
        end else begin
            case (rx_state)
                RX_IDLE: begin
                    //rx_ready <= 0;                       /*For reset read 1 byte*/
                    
                    if (!rx) begin // start bit detected
                        //rx_ready <= 1;
                        rx_state <= RX_START;
                        rx_bit_timer <= BIT_PERIOD / 2;
                    end
                end
                RX_START: begin
                    if (rx_bit_timer == 16'd0) begin
                        rx_bit_timer <= BIT_PERIOD;
                        rx_bit_idx <= 3'd0;
                        rx_state <= RX_DATA;
                    end else begin
                        rx_bit_timer <= rx_bit_timer - 1;
                    end
                end
                RX_DATA: begin
                    if (rx_bit_timer == 16'd0) begin
                        rx_shift_reg[rx_bit_idx] <= rx;
                        rx_bit_idx <= rx_bit_idx + 1;
                        rx_bit_timer <= BIT_PERIOD;
                        if (rx_bit_idx == 3'd7) begin
                            rx_state <= RX_STOP;
                        end
                    end else begin
                        rx_bit_timer <= rx_bit_timer - 1;
                    end
                end
                RX_STOP: begin
                    if (rx_bit_timer == 16'd0) begin
                        rx_data <= rx_shift_reg;
                        rx_ready <= 1'b1;
                        rx_state <= RX_IDLE;
                    end else begin
                        rx_bit_timer <= rx_bit_timer - 1;
                    end
                end
                default: rx_state <= RX_IDLE;
            endcase
        end
    end
endmodule

