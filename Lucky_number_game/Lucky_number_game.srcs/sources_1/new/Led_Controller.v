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

/*This module for controller led with fsm state*/
`include "header.vh"
 
module LED_Controller(
    input clk,                  /*This is clk from Arty-z7*/
    input rst,                  /*This is reset signal*/
    input control_mode,         /*This is configure of setting mode or playing mode @from fsmForLuckyNumberGame*/
    input [2:0] game_mode,      /*This is game mode @from fsmForLuckyNumberGame*/
    input [15:0] fsm_state,     /*This is fsm_state @from fsmForLuckyNumberGame*/
    output reg [5:0] rgb,       /*This is output for rgb led*/
    output reg [3:0] led        /*This is output for led*/
    );
    
    /*use for RGB Controller*/
    localparam TURN_ON_LED_GREEN    = 6'b010010;    //green for setting mode
    localparam TURN_ON_LED_PURPLE   = 6'b101101;    //purple for playing normal mode
    localparam TURN_ON_LED_CYAN     = 6'b110110;    //cyan led (blue and green) for playing special mode
    localparam TURN_ON_LED_RED      = 6'b001001;    //red when losing game
    localparam TURN_ON_LED_BLUE     = 6'b100100;    //blue for winning normal mode
    localparam TURN_ON_LED_YELLOW   = 6'b011011;    //yellow led (red and green) when winning special mode
    
    
    /*use for led state*/      
    localparam LED_BLINKY   = 2'b01; 
    localparam LED_NORMAL   = 2'b00;
    localparam LED_JUMP     = 2'b10;   
    
    /*use for led state*/      
    localparam RGB_BLINKY   = 1'b1; 
    localparam RGB_NORMAL   = 1'b0;     
    
    /*use for LED Controller*/
    localparam TURN_ON_LED_0        = 4'b0001;   //MODE_0: only turn on led_0
    localparam TURN_ON_LED_1        = 4'b0010;   //MODE_1: only turn on led_1
    localparam TURN_ON_LED_2        = 4'b0100;   //MODE_2: only turn on led_2
    localparam TURN_ON_LED_3        = 4'b1000;   //MODE_3: only turn on led_3
    localparam TURN_ON_LED_ALL      = 4'b1111;   //MODE_SPECIAL: turn on all led
    localparam TURN_OFF_LED_ALL     = 4'b0000;   //turn off all led when losing game


        
    wire [3:0] led_temp;    //use for updating led
    wire rgb_temp;          //use for updating rgb
    reg [1:0] led_state;    //led in blinky or normal state
    reg rgb_state;          //rgb in blinky or normal state
    reg [3:0] led_cur;      //save first state of led to start blinking

    integer i;

    
    always @(posedge clk or posedge rst)   begin
        if(rst) begin
            rgb <= TURN_ON_LED_GREEN; 
            led_state <= LED_BLINKY;    
            rgb_state <= RGB_BLINKY; 
            led_cur <= 4'b1010;             //just for winning state
            led <= TURN_ON_LED_0;
            i <= 0;
        end
        else begin
            case(fsm_state)
                /*Set led for losing game state*/
                `FSM_STATE_NO_35:   begin
                    rgb_state <= RGB_NORMAL;
                    led_state <= LED_JUMP;
                    
                    rgb <= TURN_ON_LED_RED;
                    
//                    led[0] <= led_temp[0];
//                    led[1] <= led_temp[1];
//                    led[2] <= led_temp[2];
//                    led[3] <= led_temp[3];  
                    for(i = 0; i < 4; i = i + 1)
                        led[i] <= led_temp[i];                                
                    led_cur <= ~led_cur;                 
                end
                /*Set led for winning game state*/
                `FSM_STATE_NO_36:   begin
                    led_state <= LED_BLINKY;
                    rgb_state <= RGB_BLINKY;
                    
                    rgb[3] <= 0;
                    rgb[0] <= 0;
                    rgb[5] <= rgb_temp;
                    rgb[4] <= rgb_temp;
                    rgb[2] <= rgb_temp;
                    rgb[1] <= rgb_temp;
                                        
//                    led[0] <= led_temp[0];
//                    led[1] <= led_temp[0];
//                    led[2] <= led_temp[0];
//                    led[3] <= led_temp[0];
                    for(i = 0; i < 4; i = i + 1)
                        led[i] <= led_temp[0]; 
                end
                `FSM_STATE_NO_40:   begin
                    led_state <= LED_JUMP;
                    rgb_state <= RGB_NORMAL;

                    rgb <= TURN_ON_LED_YELLOW;
                    
                    led_cur <= ~led_cur;
                    led[0] <= led_temp[0];
                    led[1] <= led_temp[1];
                    led[2] <= led_temp[2];
                    led[3] <= led_temp[3];                               
                end                                
                `FSM_STATE_NO_39:   begin
                    led_state <= LED_JUMP;
                    rgb_state <= RGB_NORMAL;
 
                    rgb <= TURN_ON_LED_YELLOW;
                    
                    led_cur <= ~led_cur;
//                    led[0] <= led_temp[0];
//                    led[1] <= led_temp[1];
//                    led[2] <= led_temp[2];
//                    led[3] <= led_temp[3];  
                    for(i = 0; i < 4; i = i + 1)
                        led[i] <= led_temp[i];                                    
                end
                default:    begin
                    case(game_mode)
                        /*LED & RGB in special mode*/
                        `GAME_MODE_SPECIAL:     begin
                            led_state <= LED_NORMAL;
                            rgb_state <= RGB_NORMAL;
                            
                            led  <= TURN_ON_LED_ALL;  
                            rgb <= TURN_ON_LED_CYAN;                         
                        end
                        /*LED & RGB: blinky for set mode and fixed for play mode*/
                        default:    begin
                            case(control_mode)
                                /*setting led & rgb for playmode*/
                                `GAME_CONTROL_PLAY_MODE:    begin
                                    rgb_state <= RGB_NORMAL;
                                    led_state <= LED_NORMAL;
                                    
                                    rgb <= TURN_ON_LED_PURPLE;
                                    
                                    if(game_mode == `GAME_MODE_0)   begin
                                        led <= TURN_ON_LED_0;    
                                    end     
                                    else if(game_mode == `GAME_MODE_1)   begin
                                        led <= TURN_ON_LED_1; 
                                    end 
                                    else if(game_mode == `GAME_MODE_2)   begin
                                        led <= TURN_ON_LED_2; 
                                    end 
                                    else if(game_mode == `GAME_MODE_3)   begin
                                        led <= TURN_ON_LED_3; 
                                    end    
                                end
                                /*setting led & rgb for setmode*/
                                default:    begin
                                    rgb_state <= RGB_BLINKY;
                                    led_state <= LED_BLINKY;                                
                                
                                    rgb[5] <= 0;
                                    rgb[0] <= 0;
                                    rgb[3:2] <= 2'b0;
                                    rgb[4] <= rgb_temp;
                                    rgb[1] <= rgb_temp;
                                    
                                    if(game_mode == `GAME_MODE_0)   begin  
                                        led[0] <= led_temp[0];
                                        led[1] <= 0;
                                        led[2] <= 0;
                                        led[3] <= 0; 
                                    end     
                                    else if(game_mode == `GAME_MODE_1)   begin 
                                        led[0] <= 0;
                                        led[1] <= led_temp[1];
                                        led[2] <= 0;
                                        led[3] <= 0;
                                    end 
                                    else if(game_mode == `GAME_MODE_2)   begin
                                        led[0] <= 0;
                                        led[1] <= 0;
                                        led[2] <= led_temp[2];
                                        led[3] <= 0;                                        
                                    end 
                                    else if(game_mode == `GAME_MODE_3)   begin
                                        led[0] <= 0;
                                        led[1] <= 0;
                                        led[2] <= 0;
                                        led[3] <= led_temp[3];                                             
                                    end 
                                end
                            endcase                                                                                 
                        end
                    endcase
                end
            endcase            
        end
    end
    
    /*Blinky Led control*/
    makeLedBlinky led0(.clk(clk),                   /*This is for blinky led module*/
                          .rst(rst),                //  @input : led_state[1:0]
                          .led_state(led_state),    // @output : led
                          .led_cur(led_cur[0]),
                          .led(led_temp[0])
                          );
    makeLedBlinky led1(.clk(clk),                   /*This is for blinky led module*/
                          .rst(rst),                //  @input : led_state[1:0]
                          .led_state(led_state),    // @output : led
                          .led_cur(led_cur[1]),
                          .led(led_temp[1])
                          );
    makeLedBlinky led2(.clk(clk),                   /*This is for blinky led module*/
                          .rst(rst),                //  @input : led_state[1:0]
                          .led_state(led_state),    // @output : led
                          .led_cur(led_cur[2]),
                          .led(led_temp[2])
                          );
    makeLedBlinky led3(.clk(clk),                   /*This is for blinky led module*/
                          .rst(rst),                //  @input : led_state[1:0]
                          .led_state(led_state),    // @output : led
                          .led_cur(led_cur[3]),
                          .led(led_temp[3])
                          );    
   /*Blinky RGB control*/
    makeRgbBlinky special_m(.clk(clk),              /*This is for blinky rgb led module*/
                            .rst(rst),              //  @input : rgb_state
                            .rgb_state(rgb_state),  // @output : rgb led
                            .rgb(rgb_temp)
                            );
endmodule