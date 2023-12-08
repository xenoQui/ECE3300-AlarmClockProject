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


// up counter bcd w/ load
module ucb
    #(parameter MAX = 9)
    (
    input ucb_clk,
    input ucb_rst,
    input ucb_en,
    input ucb_load,
    input [3:0] ucb_load_num,
    output reg [3:0] ucb_out,
    output ucb_flag
    );
    
    reg [3:0] ucb_tmp;
    
    // up counter bcd 0 -> 9 logic
    always@(posedge ucb_clk or posedge ucb_rst)
    begin
        if(ucb_rst)
            ucb_out <= 0;
        else if(ucb_en)
        begin
            if(ucb_load)
                ucb_out <= ucb_load_num;
            else
            begin
                if(ucb_out >= MAX)
                    ucb_out <= 0;
                else
                    ucb_out <= ucb_out + 1;
            end
        end
    end
    
    // flag logic
    assign ucb_flag = (ucb_out >= MAX) ? 1 : 0;
    
endmodule