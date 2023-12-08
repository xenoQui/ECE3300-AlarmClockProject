`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 03:32:25 PM
// Design Name: 
// Module Name: alarmclock
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


module alarmclock(
    input alarmclock_clk,
    input alarmclock_rst,
    input alarmclock_cm_min_rst,                // clock module (CM) 60 sec counter reset
    input alarmclock_cm_en,                     // CM enable
    input alarmclock_cm_load,                   // CM load enable
    input alarmclock_cm_load_rst,               // CM load reset
    input [1:0] alarmclock_cm_load_ud,          // CM load up/down      1: up       0: down
    input [1:0] alarmclock_cm_load_lr,          // CM load left/right   1: left     0: right
//    output [15:0] alarmclock_out_cm,            // CM out values
    output [15:0] alarmclock_led,               // unused leds 13-11, 9 
    output [7:0] alarmclock_an,
    output [6:0] alarmclock_cc
    );
    
    // CLKS
    /*--------------------------------------------------------------------*/
    wire clk_load;
    wire clk_1Hz;
    wire min;
    // clk for load
    clk_div
        #(.SIZE(25000000))
        CLK_LOAD(
        .clk(alarmclock_clk),
        .clk_div(clk_load)
        );
    
    // CLOCK MODULE
    /*--------------------------------------------------------------------*/
    wire [15:0] cm_out;
    wire [11:0] cm_led;
    clock CM(
        .clock_clk(alarmclock_clk),
        .clock_clk_load(clk_load),
        .clock_rst(alarmclock_rst),
        .clock_min_rst(alarmclock_cm_min_rst),          // reset the 60 sec counter
        .clock_en(alarmclock_cm_en),
        .clock_load(alarmclock_cm_load),
        .clock_load_rst(alarmclock_cm_load_rst),        // button to reset load values
        .clock_load_ud(alarmclock_cm_load_ud),          // button for load up/down      1: up   0: down
        .clock_load_lr(alarmclock_cm_load_lr),          // button for load left/right   1: left 0: right
        .clock_out(cm_out),
        .clock_led(cm_led)
        );
    // LEDs for each input & output of clock
    assign alarmclock_led[15:14] = cm_led[11:10];       // 11: clock_en     10: clock_load
    assign alarmclock_led[10] = cm_led[1];              // clock_min_rst
    assign alarmclock_led[8] = cm_led[0];               // clock_rst
    assign alarmclock_led[7:4] = cm_led[9:6];           // load_LR_sel
    assign alarmclock_led[3:0] = cm_led[5:2];           // load_value
    
    // 7 SEG DISPLAY
    /*--------------------------------------------------------------------*/
    wire clk_10MHz;
    wire [2:0] rc_wire;
    wire [3:0] bc_wire;
    // 1 Hz clock
    clk_div
        #(.SIZE(5000))
        CLK_10MHz(
        .clk(alarmclock_clk),
        .clk_div(clk_10MHz)
        );
    // refresh counter
    rfsh_cnt RC(
        .rc_clk(clk_10MHz),
        .rc_out(rc_wire)
        );
    // an control
    an_ctrl AN_CTRL(
        .an_ctrl_rc(rc_wire),                   // from refresh counter
        .an_out(alarmclock_an)
        );
    // bcd control
    bcd_ctrl BCD_CTRL(
        .bcd_ctrl_rc(rc_wire),                  // from refresh counter
        .bcd_ctrl_clock(cm_out),                // from clock module output
        .bcd_ctrl_out(bc_wire)                  // output to 7-seg driver
        );
    // 7 seg display
    ssd_driver SSD(
        .ssd_driver_clk(rc_wire),
        .ssd_driver_port_inp(bc_wire),          // input
        .ssd_driver_port_cc(alarmclock_cc)      // 7 segments making up the display
        );
    
endmodule
