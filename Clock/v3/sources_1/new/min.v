`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 11:42:32 AM
// Design Name: 
// Module Name: min
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


module min(
    input min_clk,
    input min_rst,
    input min_en,
    output reg min_out
    );
    
    reg [5:0] count;    
    
    always@(posedge min_clk)
    begin
        if(min_rst)
        begin
            count <= 0;
            min_out <= 0;
        end
        else if(min_en)
            count = (count > 59) ? 0 : count + 1;
        
        min_out = (count > 59) ? 1 : 0;
    end
    
endmodule
