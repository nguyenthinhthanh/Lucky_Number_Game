`define CLK_FREQUENCY           125000000   /*Clk in Arty-z7 is 125Mhz*/

`define NUM_OF_BUTTON           4           /*Num of button*/

`define TIME_PRESSED_HOLD       500         /*If button pressed more than 500ms
                                            button state is hold*/
`define COUNTER_PRESSED_HOLD    62500000    /*Counter for 500ms*/

/*This macro for button value*/
`define BUTTON_RELEASED         0
`define BUTTON_PRESSED          1
`define BUTTON_PRESSED_HOLD     2

/*This macro for button state in fsm*/
`define BUTTON_STATE_RELEASED       0
`define BUTTON_STATE_PRESSED        1
`define BUTTON_STATE_PRESSED_HOLD   2

/*This macro for game mode*/
`define GAME_MODE_0                 3'b000
`define GAME_MODE_1                 3'b001
`define GAME_MODE_2                 3'b010
`define GAME_MODE_3                 3'b011
`define GAME_MODE_SPECIAL           3'b100
