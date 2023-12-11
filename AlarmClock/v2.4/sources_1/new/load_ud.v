`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 04:05:00 PM
// Design Name: 
// Module Name: load_ud
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


// load up/down
module load_ud
    #(parameter MAX = 9)
    (
    input clk,
    input rst,
    input up,
    input down,
    output reg [3:0] out
    );
    
    always@(posedge clk)
    begin
        if(rst)
            out <= 0;
        else
        begin
            if(up)
                out <= (out >= MAX) ? 0 : out + 1;
            else if(down)
                out <= (out <= 0) ? MAX : out - 1;
        end
    end
    
endmodule
