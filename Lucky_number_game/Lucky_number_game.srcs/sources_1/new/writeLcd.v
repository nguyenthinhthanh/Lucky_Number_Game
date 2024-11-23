`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 09:57:36 AM
// Design Name: 
// Module Name: writeLcd
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


module writeLcd(
    input clk,               // Clock 125 MHz t? Arty-Z7
    input rst,
    output reg rs,           // Register Select
    output reg rw,           // Read/Write
    output reg en,           // Enable
    input [127:0] line1,
    input [127:0] line2,
    output reg [7:0] data    // Data bus cho LCD
);

    reg [31:0] counter;
    reg [7:0] state;
    reg en_pulse;            // Bi?n t?m cho tín hi?u Enable
    
    reg rs_reg;
    reg rw_reg;
    reg en_reg;
    reg[7:0] data_reg;
    
    reg[127:0] line1_prev;
    reg[127:0] line2_prev;
    

    // Các l?nh LCD
    parameter FUNCTION_SET    = 8'h38;    
    parameter DISPLAY_ON      = 8'h0C;      
    parameter CLEAR_DISPLAY   = 8'h01;   
    parameter ENTRY_MODE      = 8'h06;   ////////////////////////// Delete here    
    parameter LINE1_ADDR      = 8'h80;      
    parameter LINE2_ADDR      = 8'hC0;      

    // N?i dung hi?n th?
    /*reg [7:0] line1 [12:0];
    reg [7:0] line2 [11:0];*/

    initial begin
        rs = 0;
        rw = 0;
        en = 0;
        en_pulse = 0;
        counter = 0;
        state = 0;
        
        /*line1[0*8 +: 8]  <= "I"; line1[1*8 +: 8]  <= " "; line1[2*8 +: 8]  <= "a"; line1[3*8 +: 8]  <= "m";
        line1[4*8 +: 8]  <= " "; line1[5*8 +: 8]  <= "i"; line1[6*8 +: 8]  <= "r"; line1[7*8 +: 8]  <= "o";
        line1[8*8 +: 8]  <= "n"; line1[9*8 +: 8]  <= " "; line1[10*8 +: 8] <= "m"; line1[11*8 +: 8] <= "a";
        line1[12*8 +: 8] <= "n";
        
        line2[0]  <= 8'h49; line2[1]  <= 8'h20; line2[2]  <= "a"; line2[3]  <= "m";
        line2[4]  <= " "; line2[5]  <= "t"; line2[6]  <= "h"; line2[7]  <= "e";
        line2[8]  <= " "; line2[9]  <= "b"; line2[10] <= "e"; line2[11] <= "s";*/
        
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
            
            line1_prev <= line1;
            line2_prev <= line2;
            
        end else begin
            counter <= counter + 1;
            
            if (counter == 5000000) begin    // Kho?ng ch? gi?a các tr?ng thái
                counter <= 0;
                
                // T?o tín hi?u Enable pulse
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
                        6:  begin rs <= 1; data <= line1[0*8 +: 8];  state <= state + 1; end
                        7:  begin data <= line1[1*8 +: 8];  state <= state + 1; end
                        8:  begin data <= line1[2*8 +: 8];  state <= state + 1; end
                        9:  begin data <= line1[3*8 +: 8];  state <= state + 1; end
                        10: begin data <= line1[4*8 +: 8];  state <= state + 1; end
                        11: begin data <= line1[5*8 +: 8];  state <= state + 1; end
                        12: begin data <= line1[6*8 +: 8];  state <= state + 1; end
                        13: begin data <= line1[7*8 +: 8];  state <= state + 1; end
                        14: begin data <= line1[8*8 +: 8];  state <= state + 1; end
                        15: begin data <= line1[9*8 +: 8];  state <= state + 1; end
                        16: begin data <= line1[10*8 +: 8]; state <= state + 1; end
                        17: begin data <= line1[11*8 +: 8]; state <= state + 1; end
                        18: begin data <= line1[12*8 +: 8]; state <= state + 1; end
                        19: begin data <= line1[13*8 +: 8]; state <= state + 1; end
                        20: begin data <= line1[14*8 +: 8]; state <= state + 1; end
                        21: begin data <= line1[15*8 +: 8]; state <= state + 1; end
                        
                        // Thi?t l?p ??a ch? dòng 2
                        22: begin
                            rs <= 0; data <= LINE2_ADDR;
                            state <= state + 1;
                        end
                        // Hi?n th? dòng 2
                        23: begin rs <= 1; data <= line2[0*8 +: 8];  state <= state + 1; end
                        24: begin data <= line2[1*8 +: 8];  state <= state + 1; end
                        25: begin data <= line2[2*8 +: 8];  state <= state + 1; end
                        26: begin data <= line2[3*8 +: 8];  state <= state + 1; end
                        27: begin data <= line2[4*8 +: 8];  state <= state + 1; end
                        28: begin data <= line2[5*8 +: 8];  state <= state + 1; end
                        29: begin data <= line2[6*8 +: 8];  state <= state + 1; end
                        30: begin data <= line2[7*8 +: 8];  state <= state + 1; end
                        31: begin data <= line2[8*8 +: 8];  state <= state + 1; end
                        32: begin data <= line2[9*8 +: 8];  state <= state + 1; end
                        33: begin data <= line2[10*8 +: 8]; state <= state + 1; end
                        34: begin data <= line2[11*8 +: 8]; state <= state + 1; end
                        35: begin data <= line2[12*8 +: 8]; state <= state + 1; end
                        36: begin data <= line2[13*8 +: 8]; state <= state + 1; end
                        37: begin data <= line2[14*8 +: 8]; state <= state + 1; end
                        38: begin data <= line2[15*8 +: 8]; state <= state + 1; end
                        39: begin
                            if(line1_prev != line1 || line2_prev != line2) begin
                                state <= 0;
                            end
                            else begin
                                state <= state + 0;
                            end
                        end 
                                               
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