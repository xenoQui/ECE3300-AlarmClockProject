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
    input clock_clk_load,
    input clock_rst,
    input clock_min_rst,            // reset the 60 sec counter
    input clock_en,
    input clock_load,
    input clock_load_rst,           // button to reset load values
    input [1:0] clock_load_ud,      // button for load up/down      1: up   0: down
    input [1:0] clock_load_lr,      // button for load left/right   1: left 0: right
    output [15:0] clock_out
    );
    
    // CLKS
    /*--------------------------------------------------------------------*/
    wire clk_1Hz;
    wire min;
    // 1 Hz clock
    clk_div
        #(.SIZE(50000000))
        CLK_1Hz(
        .clk(clock_clk),
        .clk_div(clk_1Hz)
        );
    // minute counter
    min CLK_MIN(
        .min_clk(clk_1Hz),
        .min_rst(clock_rst || clock_min_rst),
        .min_en(clock_en && (clock_load == 0)),
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
        .load_ud_clk(clock_clk_load),
        .load_ud_rst(clock_rst || clock_load_rst),
        .load_ud_up(clock_load_ud[1]),
        .load_ud_down(clock_load_ud[0]),
        .load_ud_out(load_value)
        );
    // load left/right, choose a single digit to change
    load_LR LOAD_LR(
        .load_LR_clk(clock_clk_load),
        .load_LR_rst(clock_rst),
        .load_LR_en(clock_load),
        .load_LR_left(clock_load_lr[1]),
        .load_LR_right(clock_load_lr[0]),
        .load_LR_out(load_LR_sel)
        );
    
    // RST FOR 23:59
    /*--------------------------------------------------------------------*/
    reg rst_24hr_wire;
    wire [3:0] flag_tmp;    
    always@(posedge min)
    begin
        // if ((clock_en && HR_0 == 3 && MIN flags == 2'b11 && HR_1 flag == 1)   {reset all counters}
        // else {do nothing}
        rst_24hr_wire = (clock_en && (clock_out[11:8] == 3) && (flag_tmp[1:0] == 2'b11) && flag_tmp[3]) ? 1 : 0;
    end
    
    // UP COUNTER FOR CLOCK
    /*--------------------------------------------------------------------*/
    // up counter enable based on previous counter
    wire [3:1] uc_AND;
    assign uc_AND[1] = clock_en && flag_tmp[0];
    assign uc_AND[2] = uc_AND[1] && flag_tmp[1];
    assign uc_AND[3] = uc_AND[2] && flag_tmp[2];
    
    // up counter clk conditional
    wire ucb_clk_cond;
    assign ucb_clk_cond = clock_load ? clock_clk : min;
    
    // MIN_0 up counter 0 -> 9
    ucb
        #(.MAX(9))
        MIN_0(
        .ucb_clk(ucb_clk_cond),
        .ucb_rst(clock_rst || rst_24hr_wire),
        .ucb_en(clock_en || load_LR_sel[0]),
        .ucb_load(load_LR_sel[0]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out[3:0]),
        .ucb_flag(flag_tmp[0])
        );
    // MIN_1 up counter 0 -> 5
    ucb
        #(.MAX(5))
        MIN_1(
        .ucb_clk(ucb_clk_cond),
        .ucb_rst(clock_rst || rst_24hr_wire),
        .ucb_en(uc_AND[1] || load_LR_sel[1]),
        .ucb_load(load_LR_sel[1]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out[7:4]),
        .ucb_flag(flag_tmp[1])
        );
    // HR_0 up counter 0 -> 9
    ucb
        #(.MAX(9))
        HR_0(
        .ucb_clk(ucb_clk_cond),
        .ucb_rst(clock_rst || rst_24hr_wire),
        .ucb_en(uc_AND[2] || load_LR_sel[2]),
        .ucb_load(load_LR_sel[2]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out[11:8]),
        .ucb_flag(flag_tmp[2])
        );
    // HR_1 up counter 0 -> 2
    ucb
        #(.MAX(2))
        HR_1(
        .ucb_clk(ucb_clk_cond),
        .ucb_rst(clock_rst || rst_24hr_wire),
        .ucb_en(uc_AND[3] || load_LR_sel[3]),
        .ucb_load(load_LR_sel[3]),
        .ucb_load_num(load_value),
        .ucb_out(clock_out[15:12]),
        .ucb_flag(flag_tmp[3])
        );
    
endmodule
