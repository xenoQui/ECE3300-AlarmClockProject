`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 11:22:26 AM
// Design Name: 
// Module Name: ucb
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


module ucb
    #(parameter MAX = 9)
    (
    input ucb_clk,
    input ucb_rst,
    input ucb_en,
    input ucb_load,
    input [3:0] ucb_load_num,
    output [3:0] ucb_out,
    output reg ucb_flag = 0
    );
    
    reg [3:0] ucb_tmp;
    
    always@(posedge ucb_clk or posedge ucb_rst)
    begin
        if(ucb_rst)
            ucb_tmp <= 0;  
        else if(ucb_en)
        begin
            if(ucb_load)
                ucb_tmp <= ucb_load_num;
            else
            begin
                if(ucb_tmp == MAX)
                    ucb_tmp <= 0;
                else
                    ucb_tmp <= ucb_tmp + 1;
            end
            
        end
    end
    
    assign ucb_out = ucb_tmp;
    
    // flag logic
    always@(ucb_tmp)
    begin
        if(ucb_tmp >= MAX)
            ucb_flag <= 1;
        else
            ucb_flag <= 0;
    end
    
endmodule
