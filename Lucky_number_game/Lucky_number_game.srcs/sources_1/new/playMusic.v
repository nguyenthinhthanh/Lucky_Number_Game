`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 07:38:27 AM
// Design Name: 
// Module Name: playMusic
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


module playMusic(
    input wire clk,          // Clock 125 MHz t? Arty-Z7
    input wire reset,        // Nút reset
    output reg buzzer        // Tín hi?u xu?t ??n buzzer
);
    // T?n s? các n?t nh?c (theo Hz) - C5, D5, E5, F5, G5
    localparam C5 = 23889; // Chu k? = 1 / (261.63 Hz) * 125 MHz
    localparam D5 = 21282; // Chu k? = 1 / (293.66 Hz) * 125 MHz
    localparam E5 = 18961; // Chu k? = 1 / (329.63 Hz) * 125 MHz
    localparam F5 = 17807; // Chu k? = 1 / (349.23 Hz) * 125 MHz
    localparam G5 = 15804; // Chu k? = 1 / (392.00 Hz) * 125 MHz
    
    // ROM l?u chu?i n?t nh?c
    reg [15:0] notes [0:7]; 
    initial begin
        notes[0] = C5; notes[1] = D5; notes[2] = E5; notes[3] = F5;
        notes[4] = G5; notes[5] = F5; notes[6] = E5; notes[7] = D5;
    end

    reg [2:0] note_index = 0;    // Ch? s? n?t hi?n t?i
    reg [31:0] counter = 0;      // B? ??m t?n s?
    reg [31:0] duration_counter = 0; // B? ??m th?i gian phát n?t

    wire [15:0] current_note = notes[note_index]; // N?t nh?c hi?n t?i

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buzzer <= 0;
            counter <= 0;
            duration_counter <= 0;
            note_index <= 0;
        end else begin
            // ?i?u khi?n t?n s? PWM
            if (counter < current_note) 
                counter <= counter + 1;
            else begin
                counter <= 0;
                buzzer <= ~buzzer; // ??o tr?ng thái ?? t?o sóng PWM
            end

            // ??m th?i gian phát n?t
            if (duration_counter < 125_000_000 / 2) // Phát m?i n?t trong 0.5 giây
                duration_counter <= duration_counter + 1;
            else begin
                duration_counter <= 0;
                if (note_index < 7)
                    note_index <= note_index + 1; // Chuy?n sang n?t ti?p theo
                else
                    note_index <= 0; // L?p l?i giai ?i?u
            end
        end
    end
endmodule
