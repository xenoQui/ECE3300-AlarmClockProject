`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 02:38:39 AM
// Design Name: 
// Module Name: alarm_match_rgb_led_tb
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

module alarm_match_rgb_led_tb(
    );
    
    reg clk_tb; // Clock input
    reg rst_tb;
    reg led_enable_tb;
    wire PWM_r_tb; // Red LED
    wire PWM_g_tb; // Green LED
    wire PWM_b_tb; // Blue LED
    
    initial
         begin:INIT_CLK
             clk_tb = 1;
         end
     always
         begin:PERIODIC_UPDATE
             #(`clock_period/2)
             clk_tb = ~clk_tb;   
         end   
         
    alarm_match_rgb_led TB_CHP(
        .clk(clk_tb), // Clock input
        .rst(rst_tb),
        .led_enable(led_enable_tb),
        .PWM_r(PWM_r_tb), // Red LED
        .PWM_g(PWM_g_tb), // Green LED
        .PWM_b(PWM_b_tb) // Blue LED
);
    
initial
    begin: CHPTST
    rst_tb = 0;
    led_enable_tb = 0;
    
    #(`clock_period)
    rst_tb = 1;
    led_enable_tb = 1;
    
    #(`clock_period)
    rst_tb = 0;
    
    #10000
    
    $finish;
    end
    
endmodule
