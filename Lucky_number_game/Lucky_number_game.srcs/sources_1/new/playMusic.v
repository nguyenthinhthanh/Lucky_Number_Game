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
    input clk,               /*This is clk from Arty-z7*/
    input rst,               /*This is reset signal*/
    input music,             /*This is enable music*/
    output reg buzzer        /*This is output for buzzer active play music*/
);
    
    localparam C5 = 23889;       /*T = 1 / (261.63 Hz) * 125 MHz*/
    localparam D5 = 21282;       /*T = 1 / (293.66 Hz) * 125 MHz*/
    localparam E5 = 18961;       /*T = 1 / (329.63 Hz) * 125 MHz*/
    localparam F5 = 17807;       /*T = 1 / (349.23 Hz) * 125 MHz*/
    localparam G5 = 15804;       /*T = 1 / (392.00 Hz) * 125 MHz*/
    
    reg [15:0] notes [0:7];      /*This is notes for music*/    
    
    initial begin
        notes[0] = C5; notes[1] = D5; notes[2] = E5; notes[3] = F5;
        notes[4] = G5; notes[5] = F5; notes[6] = E5; notes[7] = D5;
    end

    reg [2:0] note_index = 0;                       // Current note index
    reg [31:0] counter = 0;                         // Counter  
    reg [31:0] duration_counter = 0;                // Duration for play note

    wire [15:0] current_note = notes[note_index];   // Current note 

    always @(posedge clk or posedge rst or posedge music) begin
        if (rst || music) begin
            buzzer <= 0;
            counter <= 0;
            duration_counter <= 0;
            note_index <= 0;
        end else begin
            // Creat PWM or note
            if (counter < current_note) 
                counter <= counter + 1;
            else begin
                counter <= 0;
                buzzer <= ~buzzer; 
            end

            // Time play 0.5s for each note 
            if (duration_counter < 125_000_000 / 2) 
                duration_counter <= duration_counter + 1;
            else begin
                duration_counter <= 0;
                if (note_index < 7)
                    note_index <= note_index + 1;           // Next note
                else
                    note_index <= 0;                        // Play music again
            end
        end
    end
endmodule
