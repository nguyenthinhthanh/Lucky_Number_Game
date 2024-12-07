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


module controlGameWithBluetooth(
    input wire clk,
    input wire rst,
    input wire rx,
    output wire tx
);
    wire [7:0] data_in;
    reg [7:0] data_out;
    wire tx_busy;
    wire rx_ready;
    reg data_valid;
    reg [3:0] state;
    reg [31:0] delay_counter;  // Delay counter for sending

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
