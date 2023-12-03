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
    input clock_clk,
    input clock_rst,
    input clock_en,
    input clock_load,
    input clock_load_rst,           // button to reset load values
    input [1:0] clock_load_ud,      // button for load up/down      1: up   0: down
    input [1:0] clock_load_lr,      // button for load left/right   1: left 0: right
//    output [15:0] clock_out,
    output [7:0] clock_an,
    output [6:0] clock_cc
    );
    
    // CLKS
    /*--------------------------------------------------------------------*/
    wire clk_load;
    wire clk_1Hz;
    wire min;
    // clk for load
    clk_div
        #(.SIZE(30000000))
        CLK_LOAD(
        .clk(clock_clk),
        .clk_div(clk_load)
        );
    // 1 Hz clock
    clk_div
        #(.SIZE(20000000))
        CLK_1Hz(
        .clk(clock_clk),
        .clk_div(clk_1Hz)
        );
    // minute counter
    min CLK_MIN(
        .min_clk(clk_1Hz),
        .min_en(clock_en),
        .min_out(min)
        );
    
    // LOAD
    /*--------------------------------------------------------------------*/
    wire [3:0] load_value;
    wire [3:0] load_LR_sel;
    // load value BCD 0 -> 9
    load_ud
        #(.MAX(9))
        LOAD_NUM(
        .load_ud_clk(clk_load),
        .load_ud_rst(clock_rst || clock_load_rst),
        .load_ud_up(clock_load_ud[1]),
        .load_ud_down(clock_load_ud[0]),
        .load_ud_out(load_value)
        );
    load_LR LOAD_LR(
        .load_LR_clk(clk_load),
        .load_LR_rst(clock_rst),
        .load_LR_en(clock_load),
        .load_LR_left(clock_load_lr[1]),
        .load_LR_right(clock_load_lr[0]),
        .load_LR_out(load_LR_sel)
        );
    
    // UP COUNTER FOR CLOCK
    /*--------------------------------------------------------------------*/
    wire [15:0] clock_out_wire;
    wire [3:0] flag_tmp;
    wire [3:1] uc_AND;
    assign uc_AND[1] = clock_en && flag_tmp[0];
    // MIN_0 up counter 0 -> 9
    ucb
        #(.MAX(9))
        MIN_0(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst),
        .ucb_en(clock_en || load_LR_sel[0]),
        .ucb_load(load_LR_sel[0]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out_wire[3:0]),
        .ucb_flag(flag_tmp[0])
        );
    // MIN_1 up counter 0 -> 5
    ucb
        #(.MAX(5))
        MIN_1(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst),
        .ucb_en(uc_AND[1] || load_LR_sel[1]),
        .ucb_load(load_LR_sel[1]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out_wire[7:4]),
        .ucb_flag(flag_tmp[1])
        );
    
    // 7 SEG DISPLAY
    /*--------------------------------------------------------------------*/
    wire clk_10MHz;
    wire [2:0] rc_wire;
    wire [3:0] bc_wire;
    // 1 Hz clock
    clk_div
        #(.SIZE(5000))
        CLK_10MHz(
        .clk(clock_clk),
        .clk_div(clk_10MHz)
        );
    // refresh counter
    rfsh_cnt RC(
        .rc_clk(clk_10MHz),
        .rc_out(rc_wire)
        );
    // an control
    an_ctrl AN_CTRL(
        .an_ctrl_rc(rc_wire),               // from refresh counter
        .an_out(clock_an)
        );
    // bcd control
    bcd_ctrl BCD_CTRL(
        .bcd_ctrl_rc(rc_wire),              // from refresh counter
        .clock_in(clock_out_wire),
        .bcd_ctrl_out(bc_wire)
        );
    // 7 seg display
    ssd_driver SSD(
        .ssd_driver_clk(rc_wire),
        .ssd_driver_port_inp(bc_wire),      // input
        .ssd_driver_port_cc(clock_cc)       // 7 segments making up the display
        );
        
endmodule
