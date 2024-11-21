`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2024 01:48:12 PM
// Design Name: 
// Module Name: lcdController
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


module lcdController (
    input clk,               // Clock 125 MHz to Arty-Z7
    input rst,
    input [15:0] fsm_state,
    output reg rs,           // Register Select
    output reg rw,           // Read/Write
    output reg en,           // Enable
    output reg [7:0] data    // Data bus cho LCD
);

    reg [31:0] counter;
    reg [7:0] state;
    reg en_pulse;            //Enable
    
    reg rs_reg;
    reg rw_reg;
    reg en_reg;
    reg[7:0] data_reg;

    // Các l?nh LCD
    parameter FUNCTION_SET    = 8'h38;    
    parameter DISPLAY_ON      = 8'h0C;      
    parameter CLEAR_DISPLAY   = 8'h01;   
    parameter ENTRY_MODE      = 8'h06;   ////////////////////////// Delete here    
    parameter LINE1_ADDR      = 8'h80;      
    parameter LINE2_ADDR      = 8'hC0;      

    // N?i dung hi?n th?
    reg [7:0] line1 [15:0];
    reg [7:0] line2 [15:0];

    initial begin
        rs = 0;
        rw = 0;
        en = 0;
        en_pulse = 0;
        counter = 0;
        state = 0;
        
        line1[0]  <= "I"; line1[1]  <= " "; line1[2]  <= "a"; line1[3]  <= "m";
        line1[4]  <= " "; line1[5]  <= "i"; line1[6]  <= "r"; line1[7]  <= "o";
        line1[8]  <= "n"; line1[9]  <= " "; line1[10] <= "m"; line1[11] <= "a";
        line1[12] <= "n";
        
        line2[0]  <= 8'h49; line2[1]  <= 8'h20; line2[2]  <= "a"; line2[3]  <= "m";
        line2[4]  <= " "; line2[5]  <= "t"; line2[6]  <= "h"; line2[7]  <= "e";
        line2[8]  <= " "; line2[9]  <= "b"; line2[10] <= "e"; line2[11] <= "s";
        
    end
    
    always @(posedge rst or posedge clk) begin
        if (rst) begin
            rs <= 0;
            rw <= 0;
            en <= 0;
            
            rs_reg <= 0;
            rw_reg <= 0;
            en_reg <= 0;
            
            en_pulse <= 0;
            counter <= 0;
            state <= 0;
            
            data <= 8'hFF;
            data_reg <= 8'hFF;
            
            // Kh?i t?o n?i dung hi?n th?
              case (fsm_state)
              //MODE 0:
                8'd0: begin
                    //BTN 0 to change
                    line1[0]  <= "B"; line1[1]  <= "T"; line1[2]  <= "N"; line1[3]  <= " ";
                    line1[4]  <= "0"; line1[5]  <= " "; line1[6]  <= "t"; line1[7]  <= "o";
                    line1[8]  <= " "; line1[9]  <= "c"; line1[10] <= "h"; line1[11] <= "a";
                    line1[12] <= "n"; line1[13] <= "g"; line1[14] <= "e"; line1[15] <= " ";
                    //1:set-2:back set
                    line2[0]  <= "1"; line2[1]  <= ":"; line2[2]  <= "s"; line2[3]  <= "e";
                    line2[4]  <= "t"; line2[5]  <= "-"; line2[6]  <= "2"; line2[7]  <= ":";
                    line2[8]  <= "b"; line2[9]  <= "a"; line2[10] <= "c"; line2[11] <= "k";
                    line2[12] <= " "; line2[13] <= "s"; line2[14] <= "e"; line2[15] <= "t";
                end
                //Set straight
                8'd5: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd6: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set type of straight
                8'd7: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd8: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set control mode
                8'd9: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                8'd10: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                8'd11: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                        
                
                //MDOE 1:
                8'd1: begin
                    //BTN 0 to change 
                    line1[0]  <= "B"; line1[1]  <= "T"; line1[2]  <= "N"; line1[3]  <= " ";
                    line1[4]  <= "0"; line1[5]  <= " "; line1[6]  <= "t"; line1[7]  <= "o";
                    line1[8]  <= " "; line1[9]  <= "c"; line1[10] <= "h"; line1[11] <= "a";
                    line1[12] <= "n"; line1[13] <= "g"; line1[14] <= "e"; line1[15] <= " ";
                    //1:set 2:back set
                    line2[0]  <= "1"; line2[1]  <= ":"; line2[2]  <= "s"; line2[3]  <= "e";
                    line2[4]  <= "t"; line2[5]  <= " "; line2[6]  <= "2"; line2[7]  <= ":";
                    line2[8]  <= "b"; line2[9]  <= "a"; line2[10] <= "c"; line2[11] <= "k";
                    line2[12] <= " "; line2[13] <= "s"; line2[14] <= "e"; line2[15] <= "t";
                end
                8'd12: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd13: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set type of straight
                8'd14: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd15: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set control mode
                8'd16: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd17: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd18: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd42: begin
                    //Release BTN 0
                    line1[0]  <= "R"; line1[1]  <= "e"; line1[2]  <= "l"; line1[3]  <= "e";
                    line1[4]  <= "a"; line1[5]  <= "s"; line1[6]  <= "e"; line1[7]  <= " ";
                    line1[8]  <= "B"; line1[9]  <= "T"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "0"; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= " "; line2[1]  <= " "; line2[2]  <= " "; line2[3]  <= " ";
                    line2[4]  <= " "; line2[5]  <= " "; line2[6]  <= " "; line2[7]  <= " ";
                    line2[8]  <= " "; line2[9]  <= " "; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end
                //MODE 2:
                8'd2: begin
                    //BTN 0 to change
                    line1[0]  <= "B"; line1[1]  <= "T"; line1[2]  <= "N"; line1[3]  <= " ";
                    line1[4]  <= "0"; line1[5]  <= " "; line1[6]  <= "t"; line1[7]  <= "o";
                    line1[8]  <= " "; line1[9]  <= "c"; line1[10] <= "h"; line1[11] <= "a";
                    line1[12] <= "n"; line1[13] <= "g"; line1[14] <= "e"; line1[15] <= " ";
                    //1:set-2:back set
                    line2[0]  <= "1"; line2[1]  <= ":"; line2[2]  <= "s"; line2[3]  <= "e";
                    line2[4]  <= "t"; line2[5]  <= "-"; line2[6]  <= "2"; line2[7]  <= ":";
                    line2[8]  <= "b"; line2[9]  <= "a"; line2[10] <= "c"; line2[11] <= "k";
                    line2[12] <= " "; line2[13] <= "s"; line2[14] <= "e"; line2[15] <= "t";
                end
                8'd19: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd20: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set type of straight
                8'd21: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd22: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set control mode
                8'd23: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd24: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd25: begin
                    //0:P 1:Y 2:N 3:B
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= " ";
                    line1[4]  <= "1"; line1[5]  <= ":"; line1[6]  <= "Y"; line1[7]  <= " ";
                    line1[8]  <= "2"; line1[9]  <= ":"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "3"; line1[13] <= ":"; line1[14] <= "B"; line1[15] <= " ";
                    //Hold 0 to start
                    line2[0]  <= "H"; line2[1]  <= "o"; line2[2]  <= "l"; line2[3]  <= "d";
                    line2[4]  <= " "; line2[5]  <= "0"; line2[6]  <= " "; line2[7]  <= "t";
                    line2[8]  <= "o"; line2[9]  <= " "; line2[10] <= "s"; line2[11] <= "t";
                    line2[12] <= "a"; line2[13] <= "r"; line2[14] <= "t"; line2[15] <= " ";
                end
                8'd43: begin
                    //Release BTN 0
                    line1[0]  <= "R"; line1[1]  <= "e"; line1[2]  <= "l"; line1[3]  <= "e";
                    line1[4]  <= "a"; line1[5]  <= "s"; line1[6]  <= "e"; line1[7]  <= " ";
                    line1[8]  <= "B"; line1[9]  <= "T"; line1[10] <= "N"; line1[11] <= " ";
                    line1[12] <= "0"; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //
                    line2[0]  <= " "; line2[1]  <= " "; line2[2]  <= " "; line2[3]  <= " ";
                    line2[4]  <= " "; line2[5]  <= " "; line2[6]  <= " "; line2[7]  <= " ";
                    line2[8]  <= " "; line2[9]  <= " "; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end
                //MODE 3:
                8'd3: begin
                    ////BTN 0 to change
                    line1[0]  <= "B"; line1[1]  <= "T"; line1[2]  <= "N"; line1[3]  <= " ";
                    line1[4]  <= "0"; line1[5]  <= " "; line1[6]  <= "t"; line1[7]  <= "o";
                    line1[8]  <= " "; line1[9]  <= "c"; line1[10] <= "h"; line1[11] <= "a";
                    line1[12] <= "n"; line1[13] <= "g"; line1[14] <= "e"; line1[15] <= " ";
                    //1:set-2:back set
                    line2[0]  <= "1"; line2[1]  <= ":"; line2[2]  <= "s"; line2[3]  <= "e";
                    line2[4]  <= "t"; line2[5]  <= "-"; line2[6]  <= "2"; line2[7]  <= ":";
                    line2[8]  <= "b"; line2[9]  <= "a"; line2[10] <= "c"; line2[11] <= "k";
                    line2[12] <= " "; line2[13] <= "s"; line2[14] <= "e"; line2[15] <= "t";
                end  
                8'd26: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd27: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set type of straight
                8'd28: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                8'd29: begin
                    //0:change 1:next
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "c"; line1[3]  <= "h";
                    line1[4]  <= "a"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= "1"; line1[11] <= ":";
                    line1[12] <= "n"; line1[13] <= "e"; line1[14] <= "x"; line1[15] <= "t";
                    //2:back 3:reset
                    line2[0]  <= "2"; line2[1]  <= ":"; line2[2]  <= "b"; line2[3]  <= "a";
                    line2[4]  <= "c"; line2[5]  <= "k"; line2[6]  <= " "; line2[7]  <= "3";
                    line2[8]  <= ":"; line2[9]  <= "r"; line2[10] <= "e"; line2[11] <= "s";
                    line2[12] <= "e"; line2[13] <= "t"; line2[14] <= " "; line2[15] <= " ";
                end
                //Set control mode
                8'd30: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                8'd31: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                8'd32: begin
                    //0:Play 1:Y 2:N
                    line1[0]  <= "0"; line1[1]  <= ":"; line1[2]  <= "P"; line1[3]  <= "l";
                    line1[4]  <= "a"; line1[5]  <= "y"; line1[6]  <= " "; line1[7]  <= "1";
                    line1[8]  <= ":"; line1[9]  <= "Y"; line1[10] <= " "; line1[11] <= "2";
                    line1[12] <= ":"; line1[13] <= "N"; line1[14] <= " "; line1[15] <= " ";
                    //3:Again-Hold:RST
                    line2[0]  <= "3"; line2[1]  <= ":"; line2[2]  <= "A"; line2[3]  <= "g";
                    line2[4]  <= "a"; line2[5]  <= "i"; line2[6]  <= "n"; line2[7]  <= "-";
                    line2[8]  <= "H"; line2[9]  <= "o"; line2[10] <= "l"; line2[11] <= "d";
                    line2[12] <= ":"; line2[13] <= "R"; line2[14] <= "S"; line2[15] <= "T";
                end
                8'd32: begin
                    //Press 0 to start
                    line1[0]  <= "P"; line1[1]  <= "r"; line1[2]  <= "e"; line1[3]  <= "s";
                    line1[4]  <= "s"; line1[5]  <= " "; line1[6]  <= "0"; line1[7]  <= " ";
                    line1[8]  <= "t"; line1[9]  <= "o"; line1[10] <= " "; line1[11] <= "s";
                    line1[12] <= "t"; line1[13] <= "a"; line1[14] <= "r"; line1[15] <= "t";
                    //
                    line2[0]  <= " "; line2[1]  <= " "; line2[2]  <= " "; line2[3]  <= " ";
                    line2[4]  <= " "; line2[5]  <= " "; line2[6]  <= " "; line2[7]  <= " ";
                    line2[8]  <= " "; line2[9]  <= " "; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end
                //Playing:
                8'd34: begin
                    ////Playing
                    line1[0]  <= "P"; line1[1]  <= "l"; line1[2]  <= "a"; line1[3]  <= "y";
                    line1[4]  <= "i"; line1[5]  <= "n"; line1[6]  <= "g"; line1[7]  <= " ";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= " "; line1[11] <= " ";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //
                    line2[0]  <= " "; line2[1]  <= " "; line2[2]  <= " "; line2[3]  <= " ";
                    line2[4]  <= " "; line2[5]  <= " "; line2[6]  <= " "; line2[7]  <= " ";
                    line2[8]  <= " "; line2[9]  <= " "; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd41: begin
                    ////Check result
                    line1[0]  <= "C"; line1[1]  <= "h"; line1[2]  <= "e"; line1[3]  <= "c";
                    line1[4]  <= "k"; line1[5]  <= " "; line1[6]  <= "r"; line1[7]  <= "e";
                    line1[8]  <= "s"; line1[9]  <= "u"; line1[10] <= "l"; line1[11] <= "t";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //
                    line2[0]  <= " "; line2[1]  <= " "; line2[2]  <= " "; line2[3]  <= " ";
                    line2[4]  <= " "; line2[5]  <= " "; line2[6]  <= " "; line2[7]  <= " ";
                    line2[8]  <= " "; line2[9]  <= " "; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd35: begin
                    ////You lose
                    line1[0]  <= "Y"; line1[1]  <= "o"; line1[2]  <= "u"; line1[3]  <= " ";
                    line1[4]  <= "l"; line1[5]  <= "o"; line1[6]  <= "s"; line1[7]  <= "e";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= " "; line1[11] <= " ";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //BTN 3:Play again
                    line2[0]  <= "B"; line2[1]  <= "T"; line2[2]  <= "N"; line2[3]  <= " ";
                    line2[4]  <= "3"; line2[5]  <= ":"; line2[6]  <= "P"; line2[7]  <= "l";
                    line2[8]  <= "a"; line2[9]  <= "y"; line2[10] <= " "; line2[11] <= "a";
                    line2[12] <= "g"; line2[13] <= "a"; line2[14] <= "i"; line2[15] <= "n";
                end  
                8'd36: begin
                    ////WIN-Special??
                    line1[0]  <= "W"; line1[1]  <= "I"; line1[2]  <= "N"; line1[3]  <= "-";
                    line1[4]  <= "S"; line1[5]  <= "p"; line1[6]  <= "e"; line1[7]  <= "c";
                    line1[8]  <= "i"; line1[9]  <= "a"; line1[10] <= "l"; line1[11] <= " ";
                    line1[12] <= "?"; line1[13] <= "?"; line1[14] <= " "; line1[15] <= " ";
                    //1:Yes 2:No
                    line2[0]  <= "1"; line2[1]  <= ":"; line2[2]  <= "Y"; line2[3]  <= "e";
                    line2[4]  <= "s"; line2[5]  <= " "; line2[6]  <= "2"; line2[7]  <= ":";
                    line2[8]  <= "N"; line2[9]  <= "o"; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd40: begin
                    ////YOU WIN
                    line1[0]  <= "Y"; line1[1]  <= "O"; line1[2]  <= "U"; line1[3]  <= " ";
                    line1[4]  <= "W"; line1[5]  <= "I"; line1[6]  <= "N"; line1[7]  <= " ";
                    line1[8]  <= " "; line1[9]  <= " "; line1[10] <= " "; line1[11] <= " ";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //BTN 3:Play again
                    line2[0]  <= "B"; line2[1]  <= "T"; line2[2]  <= "N"; line2[3]  <= " ";
                    line2[4]  <= "3"; line2[5]  <= ":"; line2[6]  <= "P"; line2[7]  <= "l";
                    line2[8]  <= "a"; line2[9]  <= "y"; line2[10] <= " "; line2[11] <= "a";
                    line2[12] <= "g"; line2[13] <= "a"; line2[14] <= "i"; line2[15] <= "n";
                end  
                //Special mode:
                8'd4: begin
                    ////Special game
                    line1[0]  <= "S"; line1[1]  <= "p"; line1[2]  <= "e"; line1[3]  <= "c";
                    line1[4]  <= "i"; line1[5]  <= "a"; line1[6]  <= "l"; line1[7]  <= " ";
                    line1[8]  <= "g"; line1[9]  <= "a"; line1[10] <= "m"; line1[11] <= "e";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //BTN 1:Next
                    line2[0]  <= "B"; line2[1]  <= "T"; line2[2]  <= "N"; line2[3]  <= " ";
                    line2[4]  <= "1"; line2[5]  <= ":"; line2[6]  <= "N"; line2[7]  <= "e";
                    line2[8]  <= "x"; line2[9]  <= "t"; line2[10] <= " "; line2[11] <= " ";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd37: begin
                    ////Special game
                    line1[0]  <= "S"; line1[1]  <= "p"; line1[2]  <= "e"; line1[3]  <= "c";
                    line1[4]  <= "i"; line1[5]  <= "a"; line1[6]  <= "l"; line1[7]  <= " ";
                    line1[8]  <= "g"; line1[9]  <= "a"; line1[10] <= "m"; line1[11] <= "e";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //BTN 1 to Play
                    line2[0]  <= "B"; line2[1]  <= "T"; line2[2]  <= "N"; line2[3]  <= " ";
                    line2[4]  <= "1"; line2[5]  <= " "; line2[6]  <= "t"; line2[7]  <= "o";
                    line2[8]  <= " "; line2[9]  <= "P"; line2[10] <= "l"; line2[11] <= "a";
                    line2[12] <= "y"; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd38: begin
                    ////Special game
                    line1[0]  <= "S"; line1[1]  <= "p"; line1[2]  <= "e"; line1[3]  <= "c";
                    line1[4]  <= "i"; line1[5]  <= "a"; line1[6]  <= "l"; line1[7]  <= " ";
                    line1[8]  <= "g"; line1[9]  <= "a"; line1[10] <= "m"; line1[11] <= "e";
                    line1[12] <= " "; line1[13] <= " "; line1[14] <= " "; line1[15] <= " ";
                    //Check result
                    line2[0]  <= "C"; line2[1]  <= "h"; line2[2]  <= "e"; line2[3]  <= "c";
                    line2[4]  <= "k"; line2[5]  <= " "; line2[6]  <= "r"; line2[7]  <= "e";
                    line2[8]  <= "s"; line2[9]  <= "u"; line2[10] <= "l"; line2[11] <= "t";
                    line2[12] <= " "; line2[13] <= " "; line2[14] <= " "; line2[15] <= " ";
                end  
                8'd39: begin
                    ////Win special game
                    line1[0]  <= "W"; line1[1]  <= "i"; line1[2]  <= "n"; line1[3]  <= " ";
                    line1[4]  <= "s"; line1[5]  <= "p"; line1[6]  <= "e"; line1[7]  <= "c";
                    line1[8]  <= "i"; line1[9]  <= "a"; line1[10] <= "l"; line1[11] <= " ";
                    line1[12] <= "g"; line1[13] <= "a"; line1[14] <= "m"; line1[15] <= "e";
                    //Check result
                    line2[0]  <= "3"; line2[1]  <= " "; line2[2]  <= "t"; line2[3]  <= "o";
                    line2[4]  <= " "; line2[5]  <= "P"; line2[6]  <= "l"; line2[7]  <= "a";
                    line2[8]  <= "y"; line2[9]  <= " "; line2[10] <= "a"; line2[11] <= "g";
                    line2[12] <= "a"; line2[13] <= "i"; line2[14] <= "n"; line2[15] <= " ";
                end  
                
                endcase
             
        end else begin
            counter <= counter + 1;
            
            if (counter == 5000000) begin    
                counter <= 0;
                
                //  Enable pulse
                if (en_pulse == 1) begin
                    en <= 0;
                    en_pulse <= 0;
                end else begin
                    en <= 1;
                    en_pulse <= 1;
                    
                    // X? lý theo state
                    case (state)
                        0: begin
                            rs <= 0; rw <= 0;
                            data <= FUNCTION_SET; 
                            state <= state + 1;
                        end
                        1: begin
                            data <= FUNCTION_SET;   // G?i FUNCTION_SET l?n th? hai
                            state <= state + 1;
                        end
                        2: begin
                            data <= DISPLAY_ON;  
                            state <= state + 1;
                        end
                        3: begin
                            data <= CLEAR_DISPLAY; 
                            state <= state + 1;
                        end
                        4: begin
                            data <= ENTRY_MODE;   
                            state <= state + 1;
                        end
                        5: begin
                            data <= LINE1_ADDR;   // ??a ch? b?t ??u dòng 1
                            state <= state + 1;
                        end
                        // Hi?n th? dòng 1
                        6:  begin rs <= 1; data <= line1[0];  state <= state + 1; end
                        7:  begin data <= line1[1];  state <= state + 1; end
                        8:  begin data <= line1[2];  state <= state + 1; end
                        9:  begin data <= line1[3];  state <= state + 1; end
                        10: begin data <= line1[4];  state <= state + 1; end
                        11: begin data <= line1[5];  state <= state + 1; end
                        12: begin data <= line1[6];  state <= state + 1; end
                        13: begin data <= line1[7];  state <= state + 1; end
                        14: begin data <= line1[8];  state <= state + 1; end
                        15: begin data <= line1[9];  state <= state + 1; end
                        16: begin data <= line1[10]; state <= state + 1; end
                        17: begin data <= line1[11]; state <= state + 1; end
                        18: begin data <= line1[12]; state <= state + 1; end
                        19: begin data <= line1[13]; state <= state + 1; end
                        20: begin data <= line1[14]; state <= state + 1; end
                        21: begin data <= line1[15]; state <= state + 1; end
             
                        
                        // Thi?t l?p ??a ch? dòng 2
                        22: begin
                            rs <= 0; data <= LINE2_ADDR;
                            state <= state + 1;
                        end
                        // Hi?n th? dòng 2
                        23: begin rs <= 1; data <= 8'h49;  state <= state + 1; end
                        24: begin data <= 8'h20;  state <= state + 1; end
                        25: begin data <= line2[0];  state <= state + 1; end
                        26: begin data <= line2[1];  state <= state + 1; end
                        27: begin data <= line2[2];  state <= state + 1; end
                        28: begin data <= line2[3];  state <= state + 1; end
                        29: begin data <= line2[4];  state <= state + 1; end
                        30: begin data <= line2[5];  state <= state + 1; end
                        31: begin data <= line2[6];  state <= state + 1; end
                        32: begin data <= line2[7];  state <= state + 1; end
                        33: begin data <= line2[8];  state <= state + 1; end
                        34: begin data <= line2[9];  state <= state + 1; end
                        35: begin data <= line2[10]; state <= state + 1; end
                        36: begin data <= line2[11]; state <= state + 1; end
                        37: begin data <= line2[12]; state <= state + 1; end
                        38: begin data <= line2[13]; state <= state + 1; end
                        39: begin data <= line2[14]; state <= state + 1; end
                        40: begin data <= line2[15]; state <= 0; end
                        
                        default: state <= state + 1;
                    endcase
                end
            end
            
            //rs <= rs_reg;
            //rw <= rw_reg;
            //en <= en_reg;
            //data <= data_reg;
        end
    end
endmodule


