`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rob Ranit
// 
// Create Date: 12/10/2023 09:06:35 PM
// Design Name: 
// Module Name: pixel_clk_gen_tb
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

module vga_tb(

    );
    wire [9:0] w_x_tb, w_y_tb;
    wire video_on_tb, p_tick_tb;
    wire [11:0] rgb_next_tb;
    wire hsync_tb;
    wire vsync_tb;
    reg vga_clk_tb, reset_tb;
    reg [15:0] clock_val_tb;
    reg [15:0] alarm_val_tb;
    
    initial
        begin:INIT_CLK
            vga_clk_tb = 1;
        end
    always
        begin:PERIODIC_UPDATE
            #(`clock_period/2)
            vga_clk_tb = ~vga_clk_tb;
        end
        
    vga_controller vga(
        .clk_100MHz(vga_clk_tb),
        .reset(reset_tb),
        .video_on(video_on_tb),
        .hsync(hsync_tb),
        .vsync(vsync_tb),
        .p_tick(p_tick_tb),
        .x(w_x_tb),
        .y(w_y_tb)
        );
    
    pixel_clk_gen pclk(
        .clk(vga_clk_tb),
        .video_on(video_on_tb),
        .x(w_x_tb),
        .y(w_y_tb),
        .min_1s(clock_val_tb[3:0]),
        .min_10s(clock_val_tb[7:4]),
        .hr_1s(clock_val_tb[11:8]),
        .hr_10s(clock_val_tb[15:12]),
        .alarm_min_1s(alarm_val_tb[3:0]),
        .alarm_min_10s(alarm_val_tb[7:4]),
        .alarm_hr_1s(alarm_val_tb[11:8]),
        .alarm_hr_10s(alarm_val_tb[15:12]),
        .time_rgb(rgb_next_tb)
        );
        
    initial
        begin: TST
        clock_val_tb = 0;
        alarm_val_tb = 0;
        reset_tb = 1;
        
        #(`clock_period * 5)
        reset_tb = 0;
        clock_val_tb = 16'b0000100000110000;
        
        end
endmodule
