`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 07:36:20 PM
// Design Name: 
// Module Name: min_tb
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

module min_tb(
    );
    
    reg min_clk_tb;
    reg min_rst_tb;
    reg min_en_tb;
    wire [5:0] min_count_tb;
    wire min_out_tb;
    
    // Generating clock 100 MHz
    initial
    begin:INIT_CLK
        min_clk_tb = 1;
    end
    always
    begin:PERIODIC_UPDATE
        #(`clock_period/2)
        min_clk_tb = ~min_clk_tb;
    end
    
    min TB(
        .clk(min_clk_tb),
        .rst(min_rst_tb),
        .en(min_en_tb),
        .count(min_count_tb),
        .out(min_out_tb)
        );
    
    initial
    begin
        min_rst_tb = 1;
        min_en_tb = 0;
        
        #(`clock_period)
        min_rst_tb = 0;
        min_en_tb = 1;
    end
    
endmodule
