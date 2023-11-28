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
    input min_en,
    output reg min_out
    );
    
    integer count = 0;
    
    always@(posedge min_clk)
    begin
        if(min_en)
        begin
            count <= count + 1;
            
            if(count >= 59)
                count <= 0;
        end
    end
    
    always@(count)
    begin
        if(count >= 59)
            min_out <= 1;
        else
            min_out <= 0;
    end
    
endmodule
