/*Clk in Arty-z7 is 125Mhz*/
`define CLK_FREQUENCY       125000000
/*Num of button*/
`define NUM_OF_BUTTON       4
/*If button pressed more than 500ms
button state is hold*/
`define TIME_PRESSED_HOLD   500

`define BUTTON_RELEASED     0
`define BUTTON_PRESSED      1
`define BUTTON_PRESSED_HOLD 2