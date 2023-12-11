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
    input clk,
    input rst,
    input en,
    input load_en,
    input [3:0] load_num,
    output reg [3:0] out,
    output flag
    );
    
    // up counter bcd 0 -> 9 logic
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            out <= 0;
        else if(en)
        begin
            if(load_en)
                out <= (load_num > MAX) ? MAX : load_num;
            else
                out <= (out >= MAX) ? 0 : out + 1;
        end
    end
    
    // flag logic
    assign flag = (out >= MAX) ? 1 : 0;
    
endmodule
