`define CLK_FREQUENCY           125000000   /*Clk in Arty-z7 is 125Mhz*/

`define NUM_OF_BUTTON           4           /*Num of button*/

`define NUM_OF_7SEG_MODE_0          3       /*Num of 7seg led in mode*/
`define NUM_OF_7SEG_MODE_1          3       /*Num of 7seg led in mode*/
`define NUM_OF_7SEG_MODE_2          3       /*Num of 7seg led in mode*/
`define NUM_OF_7SEG_MODE_3          3       /*Num of 7seg led in mode*/
`define NUM_OF_7SEG_MODE_SPECIAL    2       /*Num of 7seg led in mode*/

`define TIME_PRESSED_HOLD       500         /*If button pressed more than 500ms
                                            button state is hold*/
`define COUNTER_PRESSED_HOLD    125000000   /*Counter for 1000ms using 125Mhz frequency*/

/*This macro for controll speed in mode*/
`define CLK_FREQ_NORMAL_SPEED   25          /*Clk for generate random number constrain mode 2 (40ms)*/

/*This macro for speed in mode 3*/
`define MIN_SPEED_COUNTER       100         /*That mean 250ms = 100T clk button to get random number*/
`define MAX_SPEED_COUNTER       4           /*That mean 10ms = 4T clk button to get random number*/

/*This macro for button value*/
`define BUTTON_RELEASED         0
`define BUTTON_PRESSED          1
`define BUTTON_PRESSED_HOLD     2

/*This macro for button state in fsm*/
`define BUTTON_STATE_RELEASED       2'b00
`define BUTTON_STATE_PRESSED        2'b01
`define BUTTON_STATE_PRESSED_HOLD   2'b10

/*This macro for game mode*/
`define GAME_MODE_0                 3'b000
`define GAME_MODE_1                 3'b001
`define GAME_MODE_2                 3'b010
`define GAME_MODE_3                 3'b011
`define GAME_MODE_SPECIAL           3'b100

/*This macro for game control*/
`define GAME_CONTROL_SETTING_MODE   0
`define GAME_CONTROL_PLAY_MODE      1

/*This macro for game straight*/
`define GAME_NO_STRAIGHT            0
`define GAME_STRAIGHT               1

/*This macro for game type of straight*/
`define GAME_STRAIGHT_INC           0
`define GAME_STRAIGHT_DEC           1

/*This macro for state in finite state machine
  just check FSM table for see detail about state
*/

/*This macro for fsm set mode state*/
`define FSM_STATE_SET_MODE_0           0         /*This is init state, fsm state 0*/
`define FSM_STATE_SET_MODE_1           1         /*Fsm state 1*/
`define FSM_STATE_SET_MODE_2           2         /*Fsm state 2*/
`define FSM_STATE_SET_MODE_3           3         /*Fsm state 3*/

`define FSM_STATE_SET_MODE_SPECIAL     4         /*Fsm state 4*/

/*This macro for fsm set symbol number state*/
`define FSM_STATE_SET_NO_STRAIGHT      5         /*Fsm state share for 5,12,19,26 state*/
`define FSM_STATE_SET_STRAIGHT         6         /*Fsm state share for 6,13,20,27 state*/

/*This macro for fsm set type of char*/
`define FSM_STATE_SET_STRAIGHT_INC     7         /*Fsm state share for 7,14,21,28 state*/
`define FSM_STATE_SET_STRAIGHT_DEC     8         /*Fsm state share for 8,15,22,29 state*/

/*This macro for fsm set control mode*/
`define FSM_STATE_NO_STRAIGHT_PLAY     9         /*Fsm state share for 9,16,23,30 state*/
`define FSM_STATE_STRAIGHT_INC_PLAY    10        /*Fsm state share for 10,17,24,31 state*/
`define FSM_STATE_STRAIGHT_DEC_PLAY    11        /*Fsm state share for 11,18,25,32 state*/

/*This macro for play mode state*/
`define FSM_STATE_NO_33             33              /*See fsm table for detail*/
`define FSM_STATE_NO_34             34              /*See fsm table for detail*/
`define FSM_STATE_NO_35             35              /*See fsm table for detail*/
`define FSM_STATE_NO_36             36              /*See fsm table for detail*/
`define FSM_STATE_NO_37             37              /*See fsm table for detail*/
`define FSM_STATE_NO_38             38              /*See fsm table for detail*/
`define FSM_STATE_NO_39             39              /*See fsm table for detail*/
`define FSM_STATE_NO_40             40              /*See fsm table for detail*/
`define FSM_STATE_NO_42             42              /*See fsm table for detail*/
`define FSM_STATE_NO_43             43              /*See fsm table for detail*/

`define FSM_STATE_FINAL_RESULT      41              /*This is state for final result*/

/*This macro for result checker*/
`define RESULT_NORMAL               3'b000        /*Init state when not played*/
`define RESULT_LOSE                 3'b001        /*Lose this game*/
`define RESULT_WIN                  3'b010        /*Win in normal game*/
`define RESULT_SPECIAL_WIN          3'b011        /*Win in special game*/
