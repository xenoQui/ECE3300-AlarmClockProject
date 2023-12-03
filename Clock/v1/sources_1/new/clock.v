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
    input [1:0] clock_load_ud,      // button for load up/down      1: up   0: down   
    input [1:0] clock_load_lr,      // button for load left/right   1: left 0: right
//    output [15:0] clock_out,
    output [7:0] clock_an,
    output [6:0] clock_cc
    );
    
    wire [15:0] clock_out_wire;
    wire [3:0] flag_tmp;
    
    wire clk_1Hz;
    wire min;
    // 1 Hz clock
    clk_div
        #(.SIZE(30000000))
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
    
    reg cnt_rst;
    reg [3:0] num_load = 0;
    reg [1:0] load_sel = 0;
    always@(clock_load_ud or clock_load_lr or clock_load)
    begin
        if(clock_load_ud[0])            // down
        begin
            if(num_load <= 0)
                num_load <= 9;
            else
                num_load <= num_load - 1;
        end
        else if(clock_load_ud[1])       // up
        begin
            if(num_load >= 9)
                num_load <= 0;
            else
                num_load <= num_load + 1;
        end
        
        if(clock_load)
        begin
            if(clock_load_lr[0])            // right
                load_sel <= load_sel - 1;
            else if(clock_load_lr[1])       // left
                load_sel <= load_sel + 1;
        end
        else
            load_sel <= 0;
    end
    
    always@(posedge clock_clk)
    begin
        if((clock_out_wire[11:8] == 3) && flag_tmp[3] && flag_tmp[1] && flag_tmp[0])
            cnt_rst <= 1;
        else
            cnt_rst <= 0;
    end
    
    wire [3:0] load_LR;
    // left/right select for clock load
    LR_select LR_SEL(
        .LR_select_in(load_sel),
        .LR_select_out(load_LR)
        );
    
    wire [3:1] en_anded;
    assign en_anded[1] = clock_en && flag_tmp[0];
    assign en_anded[2] = en_anded[1] && flag_tmp[0] && flag_tmp[1];
    assign en_anded[3] = en_anded[2] && flag_tmp[2];
    // minute digit 0 of clock      0 -> 9
    ucb
        #(.MAX(9))
        MIN_0(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst || cnt_rst),
        .ucb_en(clock_en || load_LR[0]),
        .ucb_load(load_LR[0]),
        .ucb_load_num(num_load),
        .ucb_out(clock_out_wire[3:0]),
        .ucb_flag(flag_tmp[0])
        );
    // minute digit 1 of clock      0 -> 5
    ucb
        #(.MAX(5))
        MIN_1(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst || cnt_rst),
        .ucb_en(en_anded[1] || load_LR[1]),
        .ucb_load(load_LR[1]),
        .ucb_load_num(num_load),
        .ucb_out(clock_out_wire[7:4]),
        .ucb_flag(flag_tmp[1])
        );
    // hour digit 0 of clock        0 -> 9
    ucb
        #(.MAX(9))
        HR_0(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst || cnt_rst),
        .ucb_en(en_anded[2] || load_LR[2]),
        .ucb_load(load_LR[2]),
        .ucb_load_num(num_load),
        .ucb_out(clock_out_wire[11:8]),
        .ucb_flag(flag_tmp[2])
        );
    // hour digit 1 of clock        0 -> 2
    ucb
        #(.MAX(2))
        HR_1(
        .ucb_clk(clk_1Hz),
        .ucb_rst(clock_rst || cnt_rst),
        .ucb_en(en_anded[3] || load_LR[3]),
        .ucb_load(load_LR[3]),
        .ucb_load_num(num_load),
        .ucb_out(clock_out_wire[15:12]),
        .ucb_flag(flag_tmp[3])
        );
    
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
