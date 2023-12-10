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
    input ac_clk,
    input ac_rst,                           // alarm clock full reset
    input ac_min_rst,                       // minute counter reset
    input ac_clock_en,                      // clock enable
    input ac_clock_load,                    // clock load
    input ac_alarm_en,                      // alarm enable
    input ac_alarm_load,                    // alarm load
    input ac_load_num_rst,                  // load value reset
    input [1:0] ac_load_up_down,            // load up/down      1: up       0: down
    input [1:0] ac_load_left_right,         // load left/right   1: left     0: right
    input ac_led_en,                        // if high, disable all leds
//    output [15:0] ac_clock_out,            // CM out values
    output [7:0] ac_an,
    output [6:0] ac_cc,
    output reg [15:0] ac_led,                   // unused leds 13-11, 9 
    output ac_audio_out,
    output ac_aud_sd,
    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb,       // to DAC, to VGA Connector
    output LED_r,
    output LED_g,
    output LED_b
    );
    
    wire clk_load;
    // clk for load
    clk_div
        #(.SIZE(25000000))
        CLK_LOAD(
        .clk(ac_clk),
        .clk_div(clk_load)              // 0.5 sec
        );
    
    // CLOCK MODULE & ALARM LOAD
    /*--------------------------------------------------------------------*/
    wire [15:0] clock_val;
    wire [15:0] alarm_val;
    wire [7:0] cm_al_led;      // clock module & alarm load LEDs
    
    clock CLOCK_MODULE_ALARM_LOAD(
        .clk(ac_clk),
        .rst(ac_rst),                           // reset everything in this module
        .min_rst(ac_min_rst),                   // reset the 60 sec counter
        .en(ac_clock_en),                       // enable the clock
        .clock_load(ac_clock_load),             // switch to load values into clock
        .alarm_load(ac_alarm_load),             // switch to load values into alarm
        .load_num_rst(ac_load_num_rst),         // button to reset load values
        .load_up_down(ac_load_up_down),         // button for load up/down      1: up   0: down
        .load_left_right(ac_load_left_right),   // button for load left/right   1: left 0: right
        .led(cm_al_led),
        .clock_out(clock_val),                  // values of the clock
        .alarm_out(alarm_val)                   // values of the alarm
        );
    
    // ALARM MODULE
    /*--------------------------------------------------------------------*/
    alarm_player ALARM_PLAYER(
                             .clk(ac_clk),
                             .player_en((((alarm_val <= clock_val) == (clock_val <= alarm_val+4'b0101)) ? 1 : 0) && ac_alarm_en),               
                             .audio_out(ac_audio_out), 
                             .aud_sd(ac_aud_sd),
                             .alarm_r(LED_r),
                             .alarm_g(LED_g),
                             .alarm_b(LED_b)               
                             );
    
    // LEDs
    /*--------------------------------------------------------------------*/
    // LEDs for inputs and load outputs
    always@(posedge ac_clk)
    begin
        if(~ac_led_en)      // led enable is active low
        begin
            ac_led[15] <= ac_clock_en;
            ac_led[14] <= ac_clock_load;
            ac_led[13] <= ac_alarm_en;
            ac_led[12] <= ac_alarm_load;
            ac_led[10] <= ~ac_led_en;
            ac_led[9] <= ac_min_rst;
            ac_led[8] <= ac_rst;
            ac_led[7:4] <= cm_al_led[7:4];            // load position
            ac_led[3:0] <= cm_al_led[3:0];            // load value
        end
        else
            ac_led <= 0;
    end
    
    // 7 SEG DISPLAY
    /*--------------------------------------------------------------------*/
    wire clk_10MHz;
    wire [2:0] rc_wire;
    wire [3:0] bcd_wire;
    // 10 MHz clock
    clk_div
        #(.SIZE(5000))
        CLK_10MHz(
        .clk(ac_clk),
        .clk_div(clk_10MHz)
        );
    // refresh counter
    rfsh_cnt RFSH_CNT(
        .clk(clk_10MHz),
        .rc(rc_wire)
        );
    // an control
    an_ctrl AN_CTRL(
        .rc_in(rc_wire),                // from refresh counter
        .an_out(ac_an)                  // an out value
        );
    // bcd control
    bcd_ctrl BCD_CTRL(
        .rc_in(rc_wire),                // from refresh counter
        .clock_in(clock_val),           // clock values
        .alarm_in(alarm_val),           // alarm values
        .bcd_out(bcd_wire)              // single 4-bit output to 7-seg driver
        );
    // 7 seg display
    ssd_driver SSD(
        .clk(rc_wire),
        .num_in(bcd_wire),              // number input
        .cc_out(ac_cc)                  // 7 segments making up the display
        );
        
    // VGA Display
    wire [9:0] w_x, w_y;
    wire video_on, p_tick;
    wire [3:0] hr_10s, hr_1s, min_10s, min_1s, sec_10s, sec_1s;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    vga_controller vga(
        .clk_100MHz(ac_clk),
        //.reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(w_x),
        .y(w_y)
        );
        
     pixel_clk_gen pclk(
        .clk(ac_clk),
        .video_on(video_on),
        .alarm_status(((alarm_val == clock_val) ? 1 : 0) && ac_alarm_en),
        .x(w_x),
        .y(w_y),
        .min_1s(clock_val[3:0]),
        .min_10s(clock_val[7:4]),
        .hr_1s(clock_val[11:8]),
        .hr_10s(clock_val[15:12]),
        .alarm_min_1s(alarm_val[3:0]),
        .alarm_min_10s(alarm_val[7:4]),
        .alarm_hr_1s(alarm_val[11:8]),
        .alarm_hr_10s(alarm_val[15:12]),
        .time_rgb(rgb_next)
        );
        
         // rgb buffer
    always @(posedge ac_clk)
        if(p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg; 
        
endmodule