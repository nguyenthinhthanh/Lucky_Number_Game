`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2024 11:28:44 PM
// Design Name: 
// Module Name: Led_Controller
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

 
module LED_Controller(
    input clk,
    input rst,
    input game_straight,
    input type_of_straight,
    input [2:0] game_mode,
    input [15:0] fsm_state,
    output reg [5:0] rgb,
    output reg [3:0] led
    );
    
    /*use for RGB Controller*/
    localparam TURN_ON_LED_PURPLE_RED   =   6'b101001;    //purple for straight type & red for decreasing
    localparam TURN_ON_LED_PURPLE_BLUE  =   6'b101100;    //purple for straight type & blue for increasing
    localparam TURN_ON_LED_GREEN        =   6'b010010;    //green for normal type (no straight) & blue for increasing
    localparam TURN_ON_LED_YELLOW       =   6'b011011;    //yellow led (red and green) when winning game second time
    localparam TURN_ON_LED_CYAN         =   6'b110110;    //cyan led (blue and green) for special mode or when winning first time
    localparam TURN_OFF_ALL_LED         =   6'b0;         //turn off all led ?hen losing game
   
    /*use for led state*/      
    localparam LED_BLINKY = 1'b1; 
    localparam LED_NORMAL = 1'b0;   
    
    /*use for led state*/      
    localparam RGB_BLINKY = 1'b1; 
    localparam RGB_NORMAL = 1'b0;     
    
    /*use for LED Controller*/
    localparam TURN_ON_LED_0        = 4'b0001;   //MODE_0: only turn on led_0
    localparam TURN_ON_LED_1        = 4'b0010;   //MODE_1: only turn on led_1
    localparam TURN_ON_LED_2        = 4'b0100;   //MODE_2: only turn on led_2
    localparam TURN_ON_LED_3        = 4'b1000;   //MODE_3: only turn on led_3
    localparam TURN_ON_LED_ALL      = 4'b1111;   //MODE_SPECIAL: turn on all led
    localparam TURN_OFF_LED_ALL     = 4'b0000;   //turn off all led when losing game

    localparam TARGET_CLK_FREQ = 400;
    
    wire [3:0] led_temp;
    wire clk_out;
    wire [5:0] rgb_t;
    reg led_state;
    reg rgb_state;
    
    /*Init state: Mode_0 turn on 2 green rgb and 1 led_0*/
    initial begin
        rgb = TURN_ON_LED_GREEN;
        led  = TURN_ON_LED_0;
        led_state = LED_NORMAL;
    end
    
    always @(posedge clk /*or posedge rst*/)   begin
        if(rst) begin
            rgb <= TURN_ON_LED_GREEN;
            led  <= TURN_ON_LED_0;   
            led_state <= LED_NORMAL;    
            rgb <= RGB_NORMAL;   
        end
        else begin
            case(fsm_state)
                /*Set led for losing game state*/
                `FSM_STATE_NO_35:   begin
                    rgb <= TURN_OFF_ALL_LED;
                    led <= TURN_OFF_LED_ALL;
                    led_state <= LED_NORMAL;
                    rgb <= RGB_NORMAL;
                end
                /*Set led for winning game state*/
                `FSM_STATE_NO_36:   begin
                    led_state <= LED_BLINKY;
                    rgb_state <= RGB_BLINKY;
                    led <= led_temp;
                    rgb <= rgb_t;
                end
                `FSM_STATE_NO_40:   begin
                    rgb <= TURN_ON_LED_YELLOW;
                    led_state <= LED_BLINKY;
                    rgb_state <= RGB_NORMAL;
                    led <= led_temp;
                end                                
                `FSM_STATE_NO_39:   begin
                    rgb <= TURN_ON_LED_YELLOW;
                    led_state <= LED_BLINKY;
                    rgb_state <= RGB_NORMAL;
                    led <= led_temp;
                end
                default:    begin
                    led_state <= LED_NORMAL;
                    case(game_mode)
                        `GAME_MODE_SPECIAL:     begin
                            led  <= TURN_ON_LED_ALL; 
                            rgb_state <= RGB_BLINKY; 
                            rgb <= rgb_t;                         
                        end
                        default:    begin
                            rgb_state <= RGB_NORMAL;
                            
                            if(game_mode == `GAME_MODE_0)   begin
                                led  <= TURN_ON_LED_0;    
                            end     
                            else if(game_mode == `GAME_MODE_1)   begin
                                led  <= TURN_ON_LED_1; 
                            end 
                            else if(game_mode == `GAME_MODE_2)   begin
                                led  <= TURN_ON_LED_2; 
                            end 
                            else if(game_mode == `GAME_MODE_3)   begin
                                led  <= TURN_ON_LED_3; 
                            end
                            
                            case(game_straight)
                                `GAME_NO_STRAIGHT: begin
                                    rgb <= TURN_ON_LED_GREEN;
                                end
                                `GAME_STRAIGHT: begin
                                    if(type_of_straight == `GAME_STRAIGHT_INC)  begin
                                        rgb <= TURN_ON_LED_PURPLE_BLUE;
                                    end
                                    else if(type_of_straight == `GAME_STRAIGHT_DEC) begin
                                        rgb <= TURN_ON_LED_PURPLE_RED;
                                    end
                                end  
                                default: ;                     
                            endcase                                                                                   
                        end
                    endcase
                end
            endcase            
        end
    end
    
    /*Blinky Led just use for winning state*/
    makeLedBlinky wingame(.clk(clk),  
                          .rst(rst), 
                          .led_state(led_state), 
                          .led(led_temp)
                          );
   /*Blinky RGB just use for pre/in special mode*/
    makeRgbBlinky special_m(.clk(clk),
                            .rst(rst),
                            .rgb_state(rgb_state),
                            .rgb(rgb_t)
                            );
endmodule