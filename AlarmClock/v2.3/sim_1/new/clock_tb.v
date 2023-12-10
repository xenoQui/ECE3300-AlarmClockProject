`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 10:09:39 PM
// Design Name: 
// Module Name: clock_tb
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
`define clock_period 10

module clock_tb(
    );
    
    reg clk_tb;
    reg rst_tb;                  
    reg min_rst_tb;
    reg en_tb;
    reg clock_load_tb;
    reg alarm_load_tb;
    reg load_num_rst_tb;         
    reg [1:0] load_up_down_tb;   
    reg [1:0] load_left_right_tb;
    wire [7:0] led_tb;
    wire [15:0] clock_out_tb;
    wire [15:0] alarm_out_tb;    
    
    // Generating clock 100 MHz
    initial
    begin:INIT_CLK
        clk_tb = 1;
    end
    always
    begin:PERIODIC_UPDATE
        #(`clock_period/2)
        clk_tb = ~clk_tb;
    end
    
    clock TB(
        .clk(clk_tb),
        .rst(rst_tb),                           // reset everything in this module
        .min_rst(min_rst_tb),                   // reset the 60 sec counter
        .en(en_tb),                             // enable the clock
        .clock_load(clock_load_tb),             // switch to load values into clock
        .alarm_load(alarm_load_tb),             // switch to load values into alarm
        .load_num_rst(load_num_rst_tb),         // button to reset load values
        .load_up_down(load_up_down_tb),         // button for load up/down      1: up   0: down
        .load_left_right(load_left_right_tb),   // button for load left/right   1: left 0: right
        .led(led_tb),
        .clock_out(clock_out_tb),               // values of the clock
        .alarm_out(alarm_out_tb)                // values of the alarm
        );
    
    initial
    begin
        rst_tb = 1;
        min_rst_tb = 0;
        en_tb = 0;
        clock_load_tb = 0;
        alarm_load_tb = 0;
        load_num_rst_tb = 0;
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b00;
        #(`clock_period)
        
        // clock load enable, load 23:59, and run
        /*--------------------------------------------------------------------*/
        // clock MIN_0 increase to 9
        rst_tb = 0;
        clock_load_tb = 1;
        load_up_down_tb = 2'b10;
        #(9 * `clock_period)
        
        // next digit MIN_1
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // reset load number
        load_num_rst_tb = 1;
        load_left_right_tb = 2'b00;
        #(`clock_period)
        // MIN_1 increase to 5
        load_num_rst_tb = 0;
        load_up_down_tb = 2'b10;
        #(5 * `clock_period)
        
        // next digit HR_0
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // HR_0 decrease to 3
        load_left_right_tb = 2'b00;
        load_up_down_tb = 2'b01;
        #(2 * `clock_period)
        
        // next digit HR_1
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // HR_1 decrease to 2
        load_left_right_tb = 2'b00;
        load_up_down_tb = 2'b01;
        // disable clock load
        #(`clock_period)
        load_up_down_tb = 2'b00;
        load_num_rst_tb = 1;
        clock_load_tb = 0;
        #(`clock_period)
        
        // enable high for the clock and run
        en_tb = 1;
        load_num_rst_tb = 0;
        #(14 * `clock_period)
        // reset everything
        rst_tb = 1;
        #(`clock_period)
        
        // reset and run from 09:45
        /*--------------------------------------------------------------------*/
        // disable clock
        en_tb = 0;
        min_rst_tb = 1;
        #(`clock_period)
        
        // clock MIN_0 increase to 9
        min_rst_tb = 0;
        rst_tb = 0;
        clock_load_tb = 1;
        load_up_down_tb = 2'b10;
        #(5 * `clock_period)
        
        // next digit MIN_1
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // reset load number
        load_num_rst_tb = 1;
        load_left_right_tb = 2'b00;
        #(`clock_period)
        // MIN_1 increase to 4
        load_num_rst_tb = 0;
        load_up_down_tb = 2'b10;
        #(4 * `clock_period)
        
        // next digit HR_0
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // HR_0 increase to 9
        load_left_right_tb = 2'b00;
        load_up_down_tb = 2'b10;
        #(5 * `clock_period)
        
        // disable clock load
        clock_load_tb = 0;
        load_up_down_tb = 2'b00;
        #(`clock_period)
        en_tb = 1;
        #(12 * `clock_period)
        
        // alarm load enable, load 15:24
        /*--------------------------------------------------------------------*/
        // disable enable
        en_tb = 0;
        #(`clock_period)
        
        // alarm MIN_0 increase to 4
        alarm_load_tb = 1;
        load_up_down_tb = 2'b10;
        #(5 * `clock_period)
        
        // next digit MIN_1
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // reset load number
        load_num_rst_tb = 1;
        load_left_right_tb = 2'b00;
        #(`clock_period)
        // MIN_1 increase to 2
        load_num_rst_tb = 0;
        load_up_down_tb = 2'b10;
        #(2 * `clock_period)
        
        // next digit HR_0
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // HR_0 increase to 5
        load_left_right_tb = 2'b00;
        load_up_down_tb = 2'b10;
        #(3 * `clock_period)
        
        // next digit HR_1
        load_up_down_tb = 2'b00;
        load_left_right_tb = 2'b10;
        #(`clock_period)
        // reset load number
        load_num_rst_tb = 1;
        load_left_right_tb = 2'b00;
        #(`clock_period)
        // HR_1 increase to 1
        load_num_rst_tb = 0;
        load_up_down_tb = 2'b10;
        #(2 * `clock_period)
        
        // clear all
        /*--------------------------------------------------------------------*/
        load_up_down_tb = 2'b00;
        en_tb = 0;
        rst_tb = 1;
        #(5 * `clock_period)
        
        rst_tb = 0;
        #(`clock_period)
        
        $finish;
    end
    
endmodule
