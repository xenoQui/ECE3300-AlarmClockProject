`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 12:03:13 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div
    #(parameter SIZE = 50000000)
    (
    input clk,
    input rst,
    output reg clk_div
    );
    
    localparam constantNumber = SIZE;
    
    //localparam constantNumber = 50000000;   // 1 Hz
    //localparam constantNumber = 30000000;
    //localparam constantNumber = 5000;   // 10 KHz
    
    integer count;
 
    always @ (posedge(clk), posedge(rst))
    begin
        if (rst == 1'b1)
            count <= 32'b0;
        else if (count == constantNumber - 1)
            count <= 32'b0;
        else
            count <= count + 1;
    end
    
    always @ (posedge(clk), posedge(rst))
    begin
        if (rst == 1'b1)
            clk_div <= 1'b0;
        else if (count == constantNumber - 1)
            clk_div <= ~clk_div;
        else
            clk_div <= clk_div;
    end
    
endmodule