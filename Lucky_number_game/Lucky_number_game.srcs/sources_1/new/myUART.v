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
    input wire clk,          // Clock input
    input wire rst,          // Reset signal
    input wire rx,           // UART receive input
    output reg tx,           // UART transmit output
    input wire [7:0] data_in,  // Data to be transmitted
    output reg [7:0] data_out, // Data received
    input wire data_valid,   // Valid signal for data_in
    output reg data_ready    // Data ready signal
);

    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 125000000;
    
    localparam integer BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;
    
    // Transmitter state machine
    reg [3:0] tx_state;
    reg [7:0] tx_shift_reg;
    reg [15:0] tx_bit_counter;
    reg tx_busy;
    
    // Receiver state machine
    reg [3:0] rx_state;
    reg [7:0] rx_shift_reg;
    reg [15:0] rx_bit_counter;
    reg rx_busy;
    
    // UART transmitter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            tx_state <= 4'b0000;
            tx_shift_reg <= 8'b0;
            tx_bit_counter <= 16'b0;
        end else begin
            case (tx_state)
                4'b0000: begin
                    if (data_valid && !tx_busy) begin
                        tx_shift_reg <= data_in;
                        tx_bit_counter <= BIT_PERIOD;
                        tx <= 1'b0;  // Start bit
                        tx_busy <= 1'b1;
                        tx_state <= 4'b0001;
                    end
                end
                4'b0001: begin
                    if (tx_bit_counter == 0) begin
                        tx_bit_counter <= BIT_PERIOD;
                        tx <= tx_shift_reg[0];
                        tx_shift_reg <= {1'b0, tx_shift_reg[7:1]};
                        if (tx_shift_reg == 8'b0) begin
                            tx_state <= 4'b0010;
                        end else begin
                            tx_state <= 4'b0001;
                        end
                    end else begin
                        tx_bit_counter <= tx_bit_counter - 1;
                    end
                end
                4'b0010: begin
                    if (tx_bit_counter == 0) begin
                        tx_bit_counter <= BIT_PERIOD;
                        tx <= 1'b1;  // Stop bit
                        tx_state <= 4'b0000;
                        tx_busy <= 1'b0;
                    end else begin
                        tx_bit_counter <= tx_bit_counter - 1;
                    end
                end
                default: tx_state <= 4'b0000;
            endcase
        end
    end

    // UART receiver logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            data_ready <= 1'b0;
            rx_busy <= 1'b0;
            rx_state <= 4'b0000;
            rx_shift_reg <= 8'b0;
            rx_bit_counter <= 16'b0;
        end else begin
            case (rx_state)
                4'b0000: begin
                    if (!rx && !rx_busy) begin  // Start bit detected
                        rx_bit_counter <= BIT_PERIOD / 2;
                        rx_busy <= 1'b1;
                        rx_state <= 4'b0001;
                    end
                end
                4'b0001: begin
                    if (rx_bit_counter == 0) begin
                        rx_bit_counter <= BIT_PERIOD;
                        rx_state <= 4'b0010;
                    end else begin
                        rx_bit_counter <= rx_bit_counter - 1;
                    end
                end
                4'b0010: begin
                    if (rx_bit_counter == 0) begin
                        rx_bit_counter <= BIT_PERIOD;
                        rx_shift_reg <= {rx, rx_shift_reg[7:1]};
                        if (rx_bit_counter == 8) begin
                            rx_state <= 4'b0011;
                        end else begin
                            rx_state <= 4'b0010;
                        end
                    end else begin
                        rx_bit_counter <= rx_bit_counter - 1;
                    end
                end
                4'b0011: begin
                    data_out <= rx_shift_reg;
                    data_ready <= 1'b1;
                    rx_state <= 4'b0000;
                    rx_busy <= 1'b0;
                end
                default: rx_state <= 4'b0000;
            endcase
        end
    end
endmodule



