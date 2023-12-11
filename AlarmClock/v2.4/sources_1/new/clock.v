`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 11:20:53 AM
// Design Name: 
// Module Name: clock
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


module clock(
    input clk,
    input rst,                      // reset everything in this module
    input min_rst,                  // reset the 60 sec counter
    input en,                       // enable the clock
    input clock_load,               // switch to load values into clock
    input alarm_load,               // switch to load values into alarm
    input load_num_rst,             // button to reset load values
    input [1:0] load_up_down,       // button for load up/down      1: up   0: down
    input [1:0] load_left_right,    // button for load left/right   1: left 0: right
    output [7:0] led,               // leds for load_LR & load_ud
    output [15:0] clock_out,        // values of the clock
    output [15:0] alarm_out         // values of the alarm
    );
    
    // DIVIDED CLOCKS
    /*--------------------------------------------------------------------*/
    wire clk_load;
    wire clk_1Hz;
    wire min;
    // clk for load
    clk_div
        #(.SIZE(25000000))
        CLK_LOAD(
        .clk(clk),
        .clk_div(clk_load)              // 0.5 sec
        );
    // 1 Hz clock
    clk_div
        #(.SIZE(50000000))
        CLK_1Hz(
        .clk(clk),
        .clk_div(clk_1Hz)               // 1 sec
        );
    // minute counter
    min CLK_MIN(
        .clk(clk_1Hz),
        .rst(rst || min_rst || clock_load),
        .en(en && (clock_load == 0)),
        .out(min)                       // 60 sec
        );
    
    // UNCOMMENT BELOW FOR BITSTREAM
    /***************************************************************************************************************************************/
    
    // LOAD
    /*--------------------------------------------------------------------*/
    wire [3:0] load_val;
    wire [7:0] load_LR;
    wire [3:0] led_load_LR;
    // load value increase/decrease
    load_ud LOAD_NUM(
        .clk(clk_load),
        .rst(rst || load_num_rst),
        .up(load_up_down[1]),
        .down(load_up_down[0]),
        .out(load_val)
        );
    // load left/right, choose a single digit to change
    load_LR LOAD_LR(
        .clk(clk_load),
        .rst(rst),
        .clock_load_en(clock_load),
        .alarm_load_en(alarm_load),
        .left(load_left_right[1]),
        .right(load_left_right[0]),
        .out(load_LR),
        .led(led_load_LR)
        );
    // LEDs for load position and value
    assign led[7:4] = led_load_LR;
    assign led[3:0] = load_val;
    
    // RST FOR 23:59
    /*--------------------------------------------------------------------*/
    reg rst_24hr;
    wire [3:0] flag_tmp;
    wire rst_24hr_cond;
    assign rst_24hr_cond = (((en || clock_load == 0) && (clock_out[11:8] > 3) && flag_tmp[3]) || clock_load) ? clk : min;
    always@(posedge rst_24hr_cond)
        rst_24hr <= ((en && (clock_out[11:8] >= 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3]) || ((clock_load == 0) && (clock_out[11:8] > 3) && flag_tmp[3])) ? 1 : 0;
    
//    always@(posedge min)
//    begin
//        rst_24hr <= (en && (clock_out[11:8] >= 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3]) ? 1 : 0;
////        if(en && (clock_out[11:8] == 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3])
////            rst_24hr = 1;        {reset all clock up counters}
////        else
////            rst_24hr = 0;        {do nothing}
//    end
    
    // UP COUNTER FOR CLOCK
    /*--------------------------------------------------------------------*/
    // up counter enable based on previous counter
    wire [3:1] uc_en;
    assign uc_en[1] = en && flag_tmp[0];
    assign uc_en[2] = uc_en[1] && flag_tmp[1];
    assign uc_en[3] = uc_en[2] && flag_tmp[2];
    
    // up counter clk conditional
    wire clock_clk_cond;
    assign clock_clk_cond = (clock_load && (en == 0)) ? clk : min;
    
    // MIN_0 up counter 0 -> 9
    ucb
        #(.MAX(9))
        C_MIN0(
        .clk(clock_clk_cond),
        .rst(rst || rst_24hr),
        .en(en || load_LR[4]),
        .load_en(load_LR[4]),
        .load_num(load_val),
        .out(clock_out[3:0]),
        .flag(flag_tmp[0])
        );
    // MIN_1 up counter 0 -> 5
    ucb
        #(.MAX(5))
        C_MIN1(
        .clk(clock_clk_cond),
        .rst(rst || rst_24hr),
        .en(uc_en[1] || load_LR[5]),
        .load_en(load_LR[5]),
        .load_num(load_val),
        .out(clock_out[7:4]),
        .flag(flag_tmp[1])
        );
    // HR_0 up counter 0 -> 9
    ucb
        #(.MAX(9))
        C_HR0(
        .clk(clock_clk_cond),
        .rst(rst || rst_24hr),
        .en(uc_en[2] || load_LR[6]),
        .load_en(load_LR[6]),
        .load_num(load_val),
        .out(clock_out[11:8]),
        .flag(flag_tmp[2])
        );
    // HR_1 up counter 0 -> 2
    ucb
        #(.MAX(2))
        C_HR1(
        .clk(clock_clk_cond),
        .rst(rst || rst_24hr),
        .en(uc_en[3] || load_LR[7]),
        .load_en(load_LR[7]),
        .load_num(load_val),
        .out(clock_out[15:12]),
        .flag(flag_tmp[3])
        );
    
    // LOAD FOR ALARM
    /*--------------------------------------------------------------------*/
    // alarm load clk conditional
    wire alarm_clk_cond;
    assign alarm_clk_cond = alarm_load ? clk : min;
    // MIN_0 LOAD
    ucb
        #(.MAX(9))
        A_MIN0(
        .clk(alarm_clk_cond),
        .rst(rst),  
        .en(load_LR[0]),
        .load_en(load_LR[0]),
        .load_num(load_val),
        .out(alarm_out[3:0])
        );
    // MIN_1 LOAD
    ucb
        #(.MAX(5))
        A_MIN1(
        .clk(alarm_clk_cond), 
        .rst(rst), 
        .en(load_LR[1]),
        .load_en(load_LR[1]),
        .load_num(load_val),
        .out(alarm_out[7:4])
        );
    // HR_0 LOAD
    ucb
        #(.MAX(9))
        A_HR0(
        .clk(alarm_clk_cond), 
        .rst(rst), 
        .en(load_LR[2]),
        .load_en(load_LR[2]),
        .load_num(load_val),
        .out(alarm_out[11:8])
        );
    // HR_1 LOAD
    ucb
        #(.MAX(2))
        A_HR1(
        .clk(alarm_clk_cond),    
        .rst(rst),    
        .en(load_LR[3]),
        .load_en(load_LR[3]),
        .load_num(load_val),
        .out(alarm_out[15:12])
        );
    
    // UNCOMMENT BELOW FOR SIM
    /***************************************************************************************************************************************/
    
//    // LOAD
//    /*--------------------------------------------------------------------*/
//    wire [3:0] load_val;
//    wire [7:0] load_LR;
//    wire [3:0] led_load_LR;
//    // load value increase/decrease
//    load_ud LOAD_NUM(
//        .clk(clk),
//        .rst(rst || load_num_rst),
//        .up(load_up_down[1]),
//        .down(load_up_down[0]),
//        .out(load_val)
//        );
//    // load left/right, choose a single digit to change
//    load_LR LOAD_LR(
//        .clk(clk),
//        .rst(rst),
//        .clock_load_en(clock_load),
//        .alarm_load_en(alarm_load),
//        .left(load_left_right[1]),
//        .right(load_left_right[0]),
//        .out(load_LR),
//        .led(led_load_LR)
//        );
//    // LEDs for load position and value
//    assign led[7:4] = led_load_LR;
//    assign led[3:0] = load_val;
    
//    // RST FOR 23:59
//    /*--------------------------------------------------------------------*/
//    reg rst_24hr;
//    wire [3:0] flag_tmp;    
//    always@(posedge clk)
//    begin
//        rst_24hr <= (en && (clock_out[11:8] >= 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3]) ? 1 : 0;
////        if(en && (clock_out[11:8] == 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3])
////            rst_24hr = 1;        {reset all clock up counters}
////        else
////            rst_24hr = 0;        {do nothing}
//    end
    
//    // UP COUNTER FOR CLOCK
//    /*--------------------------------------------------------------------*/
//    // up counter enable based on previous counter
//    wire [3:1] uc_en;
//    assign uc_en[1] = en && flag_tmp[0];
//    assign uc_en[2] = uc_en[1] && flag_tmp[1];
//    assign uc_en[3] = uc_en[2] && flag_tmp[2];
    
//    // up counter clk conditional
//    wire clock_clk_cond;
//    assign clock_clk_cond = clock_load ? clk : clk;
    
//    // MIN_0 up counter 0 -> 9
//    ucb
//        #(.MAX(9))
//        C_MIN0(
//        .clk(clock_clk_cond),
//        .rst(rst || rst_24hr),
//        .en(en || load_LR[4]),
//        .load_en(load_LR[4]),
//        .load_num(load_val),
//        .out(clock_out[3:0]),
//        .flag(flag_tmp[0])
//        );
//    // MIN_1 up counter 0 -> 5
//    ucb
//        #(.MAX(5))
//        C_MIN1(
//        .clk(clock_clk_cond),
//        .rst(rst || rst_24hr),
//        .en(uc_en[1] || load_LR[5]),
//        .load_en(load_LR[5]),
//        .load_num(load_val),
//        .out(clock_out[7:4]),
//        .flag(flag_tmp[1])
//        );
//    // HR_0 up counter 0 -> 9
//    ucb
//        #(.MAX(9))
//        C_HR0(
//        .clk(clock_clk_cond),
//        .rst(rst || rst_24hr),
//        .en(uc_en[2] || load_LR[6]),
//        .load_en(load_LR[6]),
//        .load_num(load_val),
//        .out(clock_out[11:8]),
//        .flag(flag_tmp[2])
//        );
//    // HR_1 up counter 0 -> 2
//    ucb
//        #(.MAX(2))
//        C_HR1(
//        .clk(clock_clk_cond),
//        .rst(rst || rst_24hr),
//        .en(uc_en[3] || load_LR[7]),
//        .load_en(load_LR[7]),
//        .load_num(load_val),
//        .out(clock_out[15:12]),
//        .flag(flag_tmp[3])
//        );
    
//    // LOAD FOR ALARM
//    /*--------------------------------------------------------------------*/
//    // MIN_0 LOAD
//    ucb
//        #(.MAX(9))
//        A_MIN0(
//        .clk(clk),
//        .rst(rst),  
//        .en(load_LR[0]),
//        .load_en(load_LR[0]),
//        .load_num(load_val),
//        .out(alarm_out[3:0])
//        );
//    // MIN_1 LOAD
//    ucb
//        #(.MAX(5))
//        A_MIN1(
//        .clk(clk), 
//        .rst(rst), 
//        .en(load_LR[1]),
//        .load_en(load_LR[1]),
//        .load_num(load_val),
//        .out(alarm_out[7:4])
//        );
//    // HR_0 LOAD
//    ucb
//        #(.MAX(9))
//        A_HR0(
//        .clk(clk), 
//        .rst(rst), 
//        .en(load_LR[2]),
//        .load_en(load_LR[2]),
//        .load_num(load_val),
//        .out(alarm_out[11:8])
//        );
//    // HR_1 LOAD
//    ucb
//        #(.MAX(2))
//        A_HR1(
//        .clk(clk),    
//        .rst(rst),    
//        .en(load_LR[3]),
//        .load_en(load_LR[3]),
//        .load_num(load_val),
//        .out(alarm_out[15:12])
//        );
        
endmodule
